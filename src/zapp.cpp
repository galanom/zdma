#include <string>
#include <iostream>

#include <libzdma.h>

#include <cassert>
#include <ctime>
#include <cstdlib> // just for size_t !
#include <cstdio>
#include <cerrno>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include "macro.h"

#define DEV_FILE "/dev/zdma"
#define IMG_FILE "./sample.jpg"
#define SIZE (768*1024)

using namespace cv;
using namespace std;

int tdiff(struct timespec t1, struct timespec t0)
{
	return (t1.tv_sec - t0.tv_sec)*K + (t1.tv_nsec - t0.tv_nsec)/M;
}



int main(int argc, char **argv)
{
	bool verify = false;
	int err, task_num = 0, iter_num = 0, kern = 0;
	if (argc >= 3) {
		task_num = atoi(argv[1]);
		kern = atoi(argv[2]);
	}
	if (!task_num) task_num = 1;
	if (!iter_num) iter_num = 1;
	if (!kern) kern = 5;
	if (argc == 4) verify = true;

	zdma_core_register("blur", "./loopback.bit");
	Mat img = imread("./sample.jpg", CV_LOAD_IMAGE_GRAYSCALE);
	if (!img.data) {
		cout << "Failed to load image \"" << IMG_FILE << "\", exiting." << endl;
		return -1;
	}
	int img_size = img.rows * img.cols;
	cout << "Loaded image \"" << IMG_FILE << "\", size: " << img_size << endl;
	img.data[0] = 42;
	cout << "first bytes: " << int(img.data[0]) << ":" << int(img.data[1]) << ":"
		<< int(img.data[2]) << ":" << int(img.data[3]) << endl;
	Mat blur(img.size(), img.type());


	struct timespec t0, t1;
	struct zdma_task task[task_num];
	for (int j = 0; j < task_num; ++j) {
		err = zdma_task_init(&task[j]);
		assert(!err);
		err = zdma_task_configure(&task[j], "blur", img_size, img_size, 2, img.cols, kern);
		memcpy(task[j].tx_buf, img.data, img_size);
		assert(!err);
	}

	zdma_debug();
	clock_gettime(CLOCK_MONOTONIC, &t0);
	#pragma omp parallel num_threads(task_num)
	for (int i = 0; i < iter_num; ++i) {
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err = zdma_task_enqueue(&task[j]);
			///assert(!err);
		}
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err = zdma_task_waitfor(&task[j]);
			memcpy(blur.data, task[j].rx_buf, img_size);
			cout << "ret bytes: " << int(blur.data[0]) << ":" << int(blur.data[1]) << ":"
				<< int(blur.data[2]) << ":" << int(blur.data[3]) << endl;
			imwrite("out" + to_string(j) + ".jpg", blur);
			//assert(!err);
			if (verify) zdma_task_verify(&task[j]);
		}
	}
	clock_gettime(CLOCK_MONOTONIC, &t1);
	for (int j = 0; j < task_num; ++j)
		zdma_task_destroy(&task[j]);
	int t = tdiff(t1, t0);
	cout << "Exec: " << task_num << " tasks by " << iter_num << " times, time: " 
		<< t/1000 << "." << t%1000 << ", throughput: " << task_num*iter_num*SIZE/(t*1000.0) << "MiB/s" << endl;
	return 0;
}

