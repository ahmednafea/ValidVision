import face_recognition
from PIL import Image
import os
import urllib.request
import cv2
import imutils
import numpy as np
from math import hypot
import math
from flask import redirect, render_template, flash, Blueprint, url_for
from flask_login import current_user, login_user
from .models import db, User
from .import login_manager
from flask import Flask, request, redirect, jsonify, send_from_directory, send_file
from werkzeug.utils import secure_filename

app = Flask(__name__)
# app.secret_key = "secret key"
app.config['UPLOAD_FOLDER'] = 'C:/uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

# Blueprint Configuration
auth_bp = Blueprint(
    'auth_bp', __name__,
    template_folder='templates',
    static_folder='static'
)


@auth_bp.route('/signup', methods=['GET', 'POST'])
def signup():
    """
    User sign-up page.

    GET requests serve sign-up page.
    POST requests validate form & user creation.
    """
    form = SignupForm()
    if form.validate_on_submit():
        existing_user = User.query.filter_by(email=form.email.data).first()
        if existing_user is None:
            user = User(
                name=form.name.data,
                email=form.email.data,
                website=form.website.data
            )
            user.set_password(form.password.data)
            db.session.add(user)
            db.session.commit()  # Create new user
            login_user(user)  # Log in as newly created user
            return redirect(url_for('main_bp.dashboard'))
        flash('A user already exists with that email address.')
    return render_template(
        'signup.jinja2',
        title='Create an Account.',
        form=form,
        template='signup-page',
        body="Sign up for a user account."
    )


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    """
    Log-in page for registered users.

    GET requests serve Log-in page.
    POST requests validate and redirect user to dashboard.
    """
    # Bypass if user is logged in
    if current_user.is_authenticated:
        return redirect(url_for('main_bp.dashboard'))

    form = LoginForm()
    # Validate login attempt
    if form.validate_on_submit():
        user = User.query.filter_by(email=form.email.data).first()
        if user and user.check_password(password=form.password.data):
            login_user(user)
            next_page = request.args.get('next')
            return redirect(next_page or url_for('main_bp.dashboard'))
        flash('Invalid username/password combination')
        return redirect(url_for('auth_bp.login'))
    return render_template(
        'login.jinja2',
        form=form,
        title='Log in.',
        template='login-page',
        body="Log in with your User account."
    )


@login_manager.user_loader
def load_user(user_id):
    """Check if user is logged-in upon page load."""
    if user_id is not None:
        return User.query.get(user_id)
    return None


@login_manager.unauthorized_handler
def unauthorized():
    """Redirect unauthorized users to Login page."""
    flash('You must be logged in to view that page.')
    return redirect(url_for('auth_bp.login'))

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/image-upload', methods=['POST'])
def upload_image():
    # check if the post request has the file part
    if 'image' not in request.files:
        resp = jsonify({'message': 'No file part in the request'})
        resp.status_code = 400
        return resp
    file = request.files['image']
    if file.filename == '':
        resp = jsonify({'message': 'No file selected for uploading'})
        resp.status_code = 401
        return resp
    if file and allowed_file(file.filename):
        filename = secure_filename(request.form['username', file.filename])
        file.save(os.path.join(filename))
        # Initialize
        pupil_area = 0
        cat_area = 0
        cX_pupil = 0
        cY_pupil = 0
        cX_cat = 0
        cY_cat = 0

        image = face_recognition.load_image_file(filename)
        face_landmarks_list = face_recognition.face_landmarks(image)[0]
        left_eye = face_landmarks_list["left_eye"]
        right_eye = face_landmarks_list["right_eye"]
        left_eye_min_y = left_eye[0][1]
        left_eye_min_x = left_eye[0][0]
        left_eye_max_y = left_eye[0][1]
        left_eye_max_x = left_eye[0][0]
        right_eye_min_y = right_eye[0][1]
        right_eye_min_x = right_eye[0][0]
        right_eye_max_y = right_eye[0][1]
        right_eye_max_x = right_eye[0][0]
        for point in left_eye:
            if point[0] < left_eye_min_x:
                left_eye_min_x = point[0]
            if point[1] < left_eye_min_y:
                left_eye_min_y = point[1]
            if point[0] > left_eye_max_x:
                left_eye_max_x = point[0]
            if point[1] > left_eye_max_y:
                left_eye_max_y = point[1]
        for point in right_eye:
            if point[0] < right_eye_min_x:
                right_eye_min_x = point[0]
            if point[1] < right_eye_min_y:
                right_eye_min_y = point[1]
            if point[0] > right_eye_max_x:
                right_eye_max_x = point[0]
            if point[1] > right_eye_max_y:
                right_eye_max_y = point[1]
        left_eye_img = image[left_eye_min_y:left_eye_max_y, left_eye_min_x:left_eye_max_x]
        right_eye_img = image[right_eye_min_y:right_eye_max_y, right_eye_min_x:right_eye_max_x]
        left_pil_image = Image.fromarray(left_eye_img)
        left_pil_image.save(filename + "_left_img.png")
        right_pil_image = Image.fromarray(right_eye_img)
        right_pil_image.save(filename + "_right_img.png")

        # ----------------------------------------------------------

        img = cv2.imread(filename + "_left_img.png")
        img = imutils.resize(img, width=500)
        # Grayscale
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        # Parameters Calculation
        grayTemp = gray  # copy gray-scaled img to temp variable
        grayscale = grayTemp  # will be used later
        # convert Gray-scaled into black & white
        ret, grayTemp = cv2.threshold(grayTemp, 55, 255, cv2.THRESH_OTSU | cv2.THRESH_BINARY_INV)
        # Noise Removal :
        grayTemp = cv2.morphologyEx(grayTemp, cv2.MORPH_CLOSE, np.ones((5, 5), np.uint8))  # for smoothing
        grayTemp = cv2.morphologyEx(grayTemp, cv2.MORPH_ERODE, np.ones((2, 2), np.uint8))  # for deletion
        grayTemp = cv2.morphologyEx(grayTemp, cv2.MORPH_OPEN, np.ones((2, 2), np.uint8))  # for smoothing contours
        # Find Contours
        thresholdTemp = cv2.inRange(grayTemp, 250, 255)
        contours, heirarchy = cv2.findContours(thresholdTemp, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
        c = None  # To save the max contour position
        sec_c = None  # To save the second max contour position
        max_area = 0
        second_max = 0
        # get the biggest contour in the img ( biggest connected points )
        for contour in contours:
            contour_area = cv2.contourArea(contour)  # Calculates a contour area.
            if contour_area > max_area:  # if the new contour area bigger than the max area calculated in previous iterations
                second_max = max_area  # save the old max area to be the second biggest area after the biggest one
                sec_c = c  # save the old contour's array to be the second biggest contour
                max_area = contour_area  # Save the new max contour in the img
                c = contour  # Save the max contour's array
            elif contour_area > second_max:  # if the contour_area is bigger than the second max area then replace it
                second_max = contour_area  # replace the second max area with the new second max area
                sec_c = contour  # save the new contour's array to be the second max contour
        center = cv2.moments(c)  # Get the center of the biggest contour
        r = math.ceil((cv2.contourArea(
            c) / np.pi) ** 0.5)  # area=Pi*r^2  So, if we need to get r= area/Pi, get root that equals to pow(0.5)
        r = r * 0.7

        img2 = np.zeros_like(grayscale)  # create new 2d-array with the same size
        cx = int(center['m10'] / center['m00'])  # centroid of X-coordinate
        cy = int(center['m01'] / center['m00'])  # centroid of Y-coordinate
        cv2.circle(img2, (cx, cy), int(r), (255, 255, 255),
                   -1)  # Draw white circle with dimensions & color the rest of the img
        res = cv2.bitwise_and(grayscale, img2)
        resized = cv2.resize(res, (256, 256))
        mean, std = cv2.meanStdDev(resized)  # Calculates a mean and standard deviation of array elements.
        mean = mean[0][0]  # meanStdDev returns an array with mean value on [0][0] index
        std = std[0][0]
        U = abs((1 - std / mean))
        count = 0
        sum = 0

        for x in resized:  # loop on pixels of the img
            for y in x:
                if y != 0:
                    sum = sum + y
                    count = count + 1

        mean = sum / count  # the mean of the colors in the image
        deltaSum = 0
        for x in resized:
            for y in x:
                if y != 0:
                    deltaSum = (y - mean) ** 2
        std = (float(deltaSum) / count) ** 0.5
        kernel = np.ones((5, 5), np.float32) / 25  # create a 5X5 filter with 1/25=0.04
        img_filtered = cv2.filter2D(gray, -1,
                                    kernel)  # Parameters: gray-scaled img   -1:default value of anchor of the kernel
        kernelOp = np.ones((10, 10), np.uint8)  # opening Kernel
        kernelCl = np.ones((15, 15), np.uint8)

        ret, thresh_image = cv2.threshold(img_filtered, 50, 255, cv2.THRESH_BINARY_INV)
        morpho = cv2.morphologyEx(thresh_image, cv2.MORPH_OPEN, kernelOp)
        cimg_morpho = img.copy()

        # Find circular parts in the image
        circles = cv2.HoughCircles(morpho, cv2.HOUGH_GRADIENT, 1, 20, param1=10, param2=15, minRadius=0, maxRadius=0)
        if circles is None:
            # No circles Detected, Mature stage of cataract.
            resp = jsonify(
                {'message': 'Sorry our system cannot detect cataract in your eyes correctly, please try another photo'})
            resp.status_code = 201
            return resp
        # Traverse the circles
        for i in circles[0, :]:  # each i -> (x,y,radius)
            cv2.circle(cimg_morpho, (i[0], i[1]), i[2], (0, 255, 0), 2)
            cv2.circle(cimg_morpho, (i[0], i[1]), 2, (0, 0, 255), 3)  # Red point in the middle of circle
        img_morpho_copy = morpho.copy()

        # Get values(centre x, centre y, radius) for all circles
        circle_values_list = np.uint16(np.around(circles))  # convert to uint16
        x, y, r = circle_values_list[0, :][0]
        rows, cols = img_morpho_copy.shape

        for i in range(cols):
            for j in range(rows):
                # hypot() finds the Euclidean norm. The Eucledian norm is the distance from the origin to the coordinates given.
                if hypot(i - x, j - y) > r:
                    img_morpho_copy[j, i] = 0  # any pixel out of the radious area = 0
        # Bitwise Not
        img_inv = cv2.bitwise_not(img_morpho_copy)
        # FindContours for Pupil
        contours0, hierarchy = cv2.findContours(img_morpho_copy, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        cimg_pupil = img.copy()

        for cnt in contours0:
            cv2.drawContours(cimg_pupil, cnt, -1, (0, 255, 0), 3, 8)
            # img ,contour to be drawn, -1 to draw all contours if -ve draw all ,color of contour ,line thickness ,line type
            pupil_area = cv2.contourArea(cnt)
            if int(pupil_area) == 0:
                break
            M = cv2.moments(cnt)
            cX_pupil = int(M["m10"] / M["m00"])
            cY_pupil = int(M["m01"] / M["m00"])
            cv2.circle(cimg_pupil, (cX_pupil, cY_pupil), 2, (0, 0, 255), -1)

        # FindContours for Cataract
        contours0, hierarchy = cv2.findContours(img_inv, cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cimg_cat = img.copy()

        for cnt in contours0:
            if cv2.contourArea(cnt) < pupil_area:
                cv2.drawContours(cimg_cat, cnt, -1, (0, 255, 0), 3, 8)
                cat_area = cv2.contourArea(cnt)
                M = cv2.moments(cnt)
                if int(M["m00"]) == 0:
                    break
                cX_cat = int(M["m10"] / M["m00"])
                cY_cat = int(M["m01"] / M["m00"])
                cv2.circle(cimg_cat, (cX_cat, cY_cat), 2, (0, 0, 255), -1)
                print("Centre of cataract: (%d,%d)" % (cX_cat, cY_cat))
                # Difference between pupil and cataract centre
                print("Cataract is (%d,%d) away from pupil centre" % (cX_cat - cX_pupil, cY_cat - cY_pupil))
        cv2.imwrite(filename + "_FinalDetection.jpg", cimg_cat)
        # Decision Making
        if int(pupil_area) == 0:
            resp = jsonify(
                {
                    'message': 'Our system is successfully detected the cataract in your eye, You have more than 80% cataract',
                    'resultPath': 'http://192.168.0.2:8080/images/' + filename + "_FinalDetection.jpg"})
            resp.status_code = 200
            cv2.waitKey(0)
            return resp
        else:
            cataract_percentage = (cat_area / (pupil_area + cat_area)) * 100
            resp = jsonify(
                {'message': "You have %.2f percent cataract" % cataract_percentage,
                 'resultPath': 'http://192.168.0.2:8080/images/' + filename + "_FinalDetection.jpg"})
            resp.status_code = 200
            cv2.waitKey(0)
            return resp

    else:
        resp = jsonify({'message': 'Allowed file types are png, jpg, jpeg'})
        resp.status_code = 400
        return resp


@app.route('/images/<filename>')
def getImage(filename):
    return send_file(os.path.join(filename))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
