//
//  ViewController.m
//  TesseractOCRTest
//
//  Created by rimi on 2017/1/6.
//  Copyright © 2017年 iOS-ZX. All rights reserved.
//

#import "ViewController.h"
#import <TesseractOCR/TesseractOCR.h>

@interface ViewController ()<G8TesseractDelegate>

/** 按钮 **/
@property(nonatomic,strong)UIButton *btn;

/** uitextView **/
@property(nonatomic,strong)UITextView *textView;

/** 队列 **/
@property(nonatomic,strong)NSOperationQueue *operationQueue;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.view addSubview:self.btn];
}

- (void)readImages{
    NSLog(@"start");
    G8RecognitionOperation *read = [[G8RecognitionOperation alloc]initWithLanguage:@"eng"];
    read.delegate = self;
    read.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    read.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    UIImage *image1 = [UIImage imageNamed:@"1"];
    read.tesseract.image = image1;
    __weak typeof(self) weakSelf = self;
    read.recognitionCompleteBlock = ^(G8Tesseract* tesseract){
        weakSelf.textView.text = tesseract.recognizedText;
        NSLog(@"text:%@",tesseract.recognizedText);
    };
    [self.operationQueue addOperation:read];
}

- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract{
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        _btn.backgroundColor = [UIColor orangeColor];
        _btn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 60);
        [_btn setTitle:@"read" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(readImages) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 100)];
        [self.view addSubview:_textView];
    }
    return _textView;
}

@end
