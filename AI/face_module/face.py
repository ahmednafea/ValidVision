import face_recognition
from PIL import Image


def return_face(image_path):
    image = face_recognition.load_image_file(image_path)
    face_locations = face_recognition.face_locations(image)
    face_landmarks_list = face_recognition.face_landmarks(image)[0]
    top, right, bottom, left = face_locations[0]
    print(
        "A face is located at pixel location Top: {}, Left: {}, Bottom: {}, Right: {}".format(top, left, bottom, right))
    face_image = image[top:bottom, left:right]

    left_eye = face_landmarks_list["left_eye"]
    right_eye = face_landmarks_list["right_eye"]
    leftEyeMinY = left_eye[0][1]
    leftEyeMinX = left_eye[0][0]
    leftEyeMaxY = left_eye[0][1]
    leftEyeMaxX = left_eye[0][0]
    rightEyeMinY = right_eye[0][1]
    rightEyeMinX = right_eye[0][0]
    rightEyeMaxY = right_eye[0][1]
    rightEyeMaxX = right_eye[0][0]
    for point in left_eye:
        if point[0] < leftEyeMinX:
            leftEyeMinX = point[0]
        if point[1] < leftEyeMinY:
            leftEyeMinY = point[1]
        if point[0] > leftEyeMaxX:
            leftEyeMaxX = point[0]
        if point[1] > leftEyeMaxY:
            leftEyeMaxY = point[1]
    for point in right_eye:
        if point[0] < rightEyeMinX:
            rightEyeMinX = point[0]
        if point[1] < rightEyeMinY:
            rightEyeMinY = point[1]
        if point[0] > rightEyeMaxX:
            rightEyeMaxX = point[0]
        if point[1] > rightEyeMaxY:
            rightEyeMaxY = point[1]
    left_eye_img = image[leftEyeMinY:leftEyeMaxY, leftEyeMinX:leftEyeMaxX]
    right_eye_img = image[rightEyeMinY:rightEyeMaxY, rightEyeMinX:rightEyeMaxX]
    leftPilImage = Image.fromarray(left_eye_img)
    leftPilImage.show()
    rightPilImage = Image.fromarray(right_eye_img)
    rightPilImage.show()
    # print("x\t\ty")
    # for point in left_eye:
    #     print(str(point[0]) + "\t" + str(point[1]))
    # pil_image = Image.fromarray(image[left_eye[0][0]:left_eye[5][0], left_eye[0][1]:left_eye[5][1]])
    # # pil_image = Image.fromarray(face_image)
    # pil_image.show()


return_face("image.JPG")
