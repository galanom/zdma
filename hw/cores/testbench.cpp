#include "common.h"
#include <iostream>
#include <opencv2/opencv.hpp>
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
		axi_data_t all;
		uint8_t at[AXI_TDATA_NBYTES];
	} pixel;

	for (int i = 0; i < size/AXI_TDATA_NBYTES; ++i) {
		++c;
		x.data = ((axi_data_t *)img.data)[i];
		if (i == size/AXI_TDATA_NBYTES - 1) x.last = 1;
		else x.last = 0;
		src << x;
	}

	int ret = zdma_core(src, dst, img.cols, 0);
	cout << "return " << ret << endl;

	int err = 0;

	c = 0;
	do {
		dst >> x;
		((axi_data_t *)imgout.data)[c++] = x.data;
	} while (!x.last);


	imwrite("./out.jpg", imgout);
	return 0;
}
