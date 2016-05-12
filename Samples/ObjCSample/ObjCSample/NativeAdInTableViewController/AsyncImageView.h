//
//  AsyncImageView.h
//  NativeAdsSample
//
//  Created by Loïc GIRON DIT METAZ on 17/04/2014.
//  Copyright (c) 2014 Smart AdServer. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AsyncImageOperation;
@protocol AsyncImageOperationDelegate <NSObject>
- (void)imageOperation:(AsyncImageOperation *)imageOperation didDownloadImage:(UIImage *)image;
- (void)imageOperation:(AsyncImageOperation *)imageOperation didFailWithError:(NSError *)error;
@end


@interface AsyncImageView : UIImageView <AsyncImageOperationDelegate> {
	AsyncImageOperation *_currentOperation;
}

- (void)setImageURL:(NSURL *)imageURL;

@end
