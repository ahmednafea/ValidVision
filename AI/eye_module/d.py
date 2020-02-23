# author none
import cv2
def Eye_Detect(img):
	eye_cascade = cv2.CascadeClassifier('eye.xml')
	gra =cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
	eye = eye_cascade.detectMultiScale(gra, 1.2, 4)
	#print("image")
	#print(img)

	# get dimensions of image
	dimensions = img.shape

	# height, width, number of channels in image
	height = dimensions[0]
	width = dimensions[1]
	#channels = dimensions[2]

	#print('Image Height       : ',height)
	#print('Image Width        : ',width)

	x,y,w,h=eye[0]
	#print(x," ",y)

	height=height/2
	width=int(width/2)


	if (x<width): # gab al ymeen
		crp=img[y:y+h, x:]
		gra = cv2.cvtColor(crp, cv2.COLOR_BGR2GRAY)
		eyes = eye_cascade.detectMultiScale(gra, 1.2, 4)

	elif (x>width): # gab al shmal
		crp=img[y:y+h, 0:x+w]
		gra = cv2.cvtColor(crp, cv2.COLOR_BGR2GRAY)
		eyes = eye_cascade.detectMultiScale(gra, 1.2, 4)

	idx = 1
	for (x,y,w,h) in eyes:
		cv2.rectangle(crp, (x,y), (x+w, y+h), (255,255,0), 2)
		cv2.imshow('Detection', crp)
		crop_img = crp[y: y + h, x: x + w, :]
		cv2.imwrite("cropped/"+str(idx) + '.jpg', crop_img);
		idx += 1

	#cv2.imwrite("Gray_Image.jpg", crp);
	#cv2.imshow('Detection', crp)
	cv2.waitKey(0)
	cv2.destroyAllWindows()


img = cv2.imread('8.jpg')
Eye_Detect(img)
