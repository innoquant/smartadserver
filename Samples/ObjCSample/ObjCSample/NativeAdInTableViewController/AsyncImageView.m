//
//  AsyncImageView.m
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 17/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import "AsyncImageView.h"

static NSOperationQueue *imageOperationQueue = nil;


@interface AsyncImageOperation : NSOperation {
	id<AsyncImageOperationDelegate> _delegate;
	NSURL *_imageURL;
}

@property CGSize desiredImageSize;

@end

@implementation AsyncImageOperation

- (instancetype)initWithImageURL:(NSURL *)imageURL delegate:(id<AsyncImageOperationDelegate>)delegate {
	self = [super init];
	
	if (self) {
		_imageURL = imageURL;
		_delegate = delegate;
		_desiredImageSize = CGSizeZero;
		
		//Priority is a number between 0.0 and 1.0, default priority is 0.5.
		[self setThreadPriority:0.1f];
	}
	
	return self;
}


- (void)main {
	@autoreleasepool {
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:_imageURL];
		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
		[self handleRequestResponseWithData:data error:error];
	}
}


- (void)handleRequestResponseWithData:(NSData *)data error:(NSError *)error {
	if (error == nil) {
		UIImage *image = [self imageFromData:data];
		[self successWithImage:image];
	} else {
		[self failureWithError:error];
	}
}


- (UIImage *)imageFromData:(NSData *)data {
	UIImage *image = [[UIImage alloc] initWithData:data];
	
	return image;
}


- (UIImage *)rescaledImage:(UIImage *)image withSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *rescaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return rescaledImage;
}


- (void)successWithImage:(UIImage *)image {
	// The delegate is called in the main thread, only if the operation has not been cancelled.
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		if ([self isCancelled] == NO && _delegate && [_delegate respondsToSelector:@selector(imageOperation:didDownloadImage:)]) {
			[_delegate imageOperation:self didDownloadImage:image];
		}
	});
}


- (void)failureWithError:(NSError *)error {
	// The delegate is called in the main thread, only if the operation has not been cancelled.
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		if ([self isCancelled] == NO && _delegate && [_delegate respondsToSelector:@selector(imageOperation:didFailWithError:)]) {
			[_delegate imageOperation:self didFailWithError:error];
		}
	});
}

@end


@implementation AsyncImageView

- (void)setImageURL:(NSURL *)imageURL {
	[self configureQueueAndCancelPreviousOperations];
	[self setImage:nil];
	[self downloadImageWithURL:imageURL];
}


- (void)configureQueueAndCancelPreviousOperations {
	if (imageOperationQueue == nil) {
		imageOperationQueue = [[NSOperationQueue alloc] init];
		[imageOperationQueue setMaxConcurrentOperationCount:1];
	}
	[_currentOperation cancel];
}


- (void)downloadImageWithURL:(NSURL *)imageURL {
	_currentOperation = [[AsyncImageOperation alloc] initWithImageURL:imageURL delegate:self];
	_currentOperation.desiredImageSize = self.frame.size;
	[imageOperationQueue addOperation:_currentOperation];
}

#pragma mark - AsyncImageOperation delegate

- (void)imageOperation:(AsyncImageOperation *)imageOperation didDownloadImage:(UIImage *)image {
	[self setImage:image];
    [self setContentMode:UIViewContentModeScaleAspectFit];
	_currentOperation = nil;
}


- (void)imageOperation:(AsyncImageOperation *)imageOperation didFailWithError:(NSError *)error {
	_currentOperation = nil;
}

@end
