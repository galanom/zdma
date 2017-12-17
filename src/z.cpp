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

using namespace cv;
using namespace std;

int tdiff(struct timespec t1, struct timespec t0)
{
	return (t1.tv_sec - t0.tv_sec)*K + (t1.tv_nsec - t0.tv_nsec)/M;
}



int main(int argc, char **argv)
{
	bool verify = false;
	int err, task_num = 0, iter_num = 0;

	if (argc >= 2)
		task_num = atoi(argv[1]);
	if (argc >= 3)
		iter_num = atoi(argv[2]);
	if (!task_num)
		task_num = 1;
	if (!iter_num) 
		iter_num = 1;
	if (argc >= 4)
		verify = true;

	zdma_core_register("sobel", 1, -1);
	zdma_core_register("gauss", 1, -1);
	zdma_core_register("outline", 1, -1);
	zdma_core_register("sharpen", 1, -1);
	zdma_core_register("emboss", 1, -1);
	zdma_core_register("negative", 1, -1);
	zdma_core_register("contrast", 1, -1);
	zdma_core_register("threshold", 1, -1);
	int core_num = 8;

	Mat img = imread("./sample.jpg", CV_LOAD_IMAGE_GRAYSCALE);
	if (!img.data) {
		cout << "Failed to load image \"" << IMG_FILE << "\", exiting." << endl;
		return -1;
	}
	int img_size = img.rows * img.cols;
	
	Mat out[task_num];
	struct zdma_task task[task_num];

	// pre-configure task initialization
	for (int i = 0; i < task_num; ++i) {
		out[i].create(img.size(), img.type());
		err = zdma_task_init(&task[i]);
		assert(!err);
		if (i % core_num == 0)
			err  = zdma_task_configure(&task[i], "sobel", -1, img_size, img_size, 2, img.cols, 0);
		else if (i % core_num == 1)
			err  = zdma_task_configure(&task[i], "gauss", -1, img_size, img_size, 1, img.cols);
		else if (i % core_num == 2)
			err  = zdma_task_configure(&task[i], "outline", -1, img_size, img_size, 1, img.cols);
		else if (i % core_num == 3)
			err  = zdma_task_configure(&task[i], "sharpen", -1, img_size, img_size, 1, img.cols);
		else if (i < 5*task_num / 8)
			err  = zdma_task_configure(&task[i], "emboss", -1, img_size, img_size, 1, img.cols);
		else if (i < 6*task_num / 8)
			err  = zdma_task_configure(&task[i], "contrast", -1, img_size, img_size, 1, 20, -100);
		else if (i < 7*task_num / 8)
			err  = zdma_task_configure(&task[i], "threshold", -1, img_size, img_size, 1, 127);
		else
			err  = zdma_task_configure(&task[i], "negative", -1, img_size, img_size, 0);
		assert(!err);
		memcpy(task[i].tx_buf, img.data, img_size);
	}

	//zdma_debug();
	
	struct timespec t0, t1;
	clock_gettime(CLOCK_MONOTONIC, &t0);
	#pragma omp parallel num_threads(task_num)
	for (int i = 0; i < iter_num; ++i) {
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err = zdma_task_enqueue(&task[j]);
			assert(!err);
		}
		
		#pragma omp for
		for (int j = 0; j < task_num; ++j) {
			err = zdma_task_waitfor(&task[j]);
			assert(!err);
			if (verify) {
				memcpy(out[j].data, task[j].rx_buf, img_size);
				imwrite("t" + to_string(j) + "r" + to_string(i)	+ 
					"." + task[j].conf.core_name + ".jpg", out[j]);
			}
		}
	}
	
	err = zdma_barrier();
	assert(!err);

	clock_gettime(CLOCK_MONOTONIC, &t1);
	
	for (int j = 0; j < task_num; ++j)
		zdma_task_destroy(&task[j]);

	int t = tdiff(t1, t0);
	cout << "Exec: " << task_num << " tasks by " << iter_num << " times, time: " 
		<< t/1000 << "." << t%1000 << ", throughput: " << 
		task_num*iter_num*(long long)img_size/(t*1000.0) << "MiB/s" << endl;
	return 0;
}

