import sys
import cv2
import numpy as np

from os.path 					import splitext, basename, isfile
from src.utils 					import image_files_from_folder
from src.drawing_utils			import blur_license_plate
from src.label 					import lread, readShapes

input_dir = sys.argv[1]
output_dir = sys.argv[2]

img_files = image_files_from_folder(input_dir)

for img_file in img_files:

	bname = splitext(basename(img_file))[0]

	I = cv2.imread(img_file)

	detected_cars_labels = '%s/%s_cars.txt' % (output_dir,bname)

	Lcar = lread(detected_cars_labels)

	if Lcar:

		for i,lcar in enumerate(Lcar):

			lp_label 		= '%s/%s_%dcar_lp.txt'		% (output_dir,bname,i)
			lp_label_str 	= '%s/%s_%dcar_lp_str.txt'	% (output_dir,bname,i)

			if isfile(lp_label):

				Llp_shapes = readShapes(lp_label)
				pts = Llp_shapes[0].pts*lcar.wh().reshape(2,1) + lcar.tl().reshape(2,1)
				ptspx = pts*np.array(I.shape[1::-1],dtype=float).reshape(2,1)

				I = blur_license_plate(I,ptspx)

	cv2.imwrite('%s/%s_LP_blurred.png' % (output_dir,bname),I)


