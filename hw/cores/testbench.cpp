#include <iostream>
#include "common.h"
#include "hls_opencv.h"
using namespace cv;
using namespace std;
int main (int argc, char* argv[]) {
	Mat img = imread("./sample.jpg", CV_LOAD_IMAGE_GRAYSCALE);
	Mat imgout(img.size(), img.type());
	hls::stream<axi_elem_t> src, dst;

	int c = 0;
	axi_elem_t x;
	int size = img.rows * img.cols;

	union {
		uint64_t all;
		uint8_t at[8];
	} pixel;

	for (int i = 0; i < size/8; ++i) {
		++c;
		x.data = ((uint64_t *)img.data)[i];
		if (i == size/8 - 1) x.last = 1;
		else x.last = 0;
		src << x;
	}
//	ap_uint<4> debug;
	//int32_t ret = loopback(src, dst);
	int ret = blur(src, dst, img.cols, 11);
	//int ret = gauss(src, dst, img.cols);
	//int32_t ret = outline(src, dst, img.cols);
	//int ret = sobel(src, dst, img.cols, 0);
	//int32_t ret = emboss(src, dst, img.cols);
	//int32_t ret = sharpen(src, dst, img.cols);
	//int32_t ret = contrast(src, dst, 0, 40);
	//int32_t ret = gamma(src, dst, 0.5f);

	int err = 0;

	c = 0;
	do {
		dst >> x;
		((uint64_t *)imgout.data)[c++] = x.data;
	} while (!x.last);

	cout << "return value is " << ret << endl;
	cout << int(imgout.data[0]) << ":" << int(imgout.data[1]) << ":" <<
			int(imgout.data[2]) << ":" << int(imgout.data[3]) << ":" <<
			int(imgout.data[4]) << ":" << int(imgout.data[5]) << ":" <<
			int(imgout.data[6]) << ":" << int(imgout.data[7]) << endl;

	imwrite("./out1.jpg", imgout);
	return 0;
}
