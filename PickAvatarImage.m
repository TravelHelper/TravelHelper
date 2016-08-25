//
//  PickAvatarImage.m
//  UIImagePickerContrlllerTest
//
//  Created by sks on 16/7/15.
//  Copyright © 2016年 AlexianAnn. All rights reserved.
//

#import "PickAvatarImage.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"


@interface PickAvatarImage()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSURL *movieURL;
@property (copy,nonatomic) NSString *lastChosenMediaType;

@end

@implementation PickAvatarImage


-(void)createActionSheetWithView{

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相机",@"本机相册",nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.selfController.view];
    
}


#pragma mark -ActionSheet协议
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
            break;
        }
            
        case 1:{
            [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
        default:
            break;
    }
    
    
}

#pragma mark -选择媒体类型
-(void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0){
        
        //        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.selfController presentViewController:picker animated:YES completion:nil];
    }
    else{
        
//        NSLog(@"UUUU");
        
    }
    
}


#pragma mark -裁剪方法
-(UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size{
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGFloat originalAspect = original.size.width /original.size.height;
    CGFloat targetAspect = size.width / size.height;
    CGRect targetRect;
    
    
    if(originalAspect > targetAspect){
        //原图片比头像选取框宽
        targetRect.size.width = size.width;
        targetRect.size.height = size.height * targetAspect / originalAspect;
        targetRect.origin.x = 0;
        targetRect.origin.y = (size.height - targetRect.size.height) * 0.5;
        
    }else if(originalAspect < targetAspect){
        //原图片比头像选取框窄
        targetRect.size.width = size.width * originalAspect / targetAspect;
        targetRect.size.height = size.height;
        targetRect.origin.x = (size.width - targetRect.size.width) * 0.5;
        targetRect.origin.y = 0;
        
    }else{
        //原图片与选取框尺寸相同
        targetRect = CGRectMake(0, 0, size.width, size.height);
        
    }
    
    [original drawInRect:targetRect];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
    
}

#pragma mark -imagePickerController协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]){
        
//        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//        
//        self.image = [self shrinkImage:chosenImage toSize:self.avatarImageView.bounds.size];
        
        self.image =image;
        
        
        
        
        NSString *urlc=[NSString stringWithFormat:@"http://%@/TravelHelper/upload.php",serviseId];
        NSURL *URL = [NSURL URLWithString:urlc];
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager setSecurityPolicy:securityPolicy];
        [manager POST:URL.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //获取当前时间所闻文件名，防止图片重复
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
//            NSDictionary *myDictionary = [userinfo dictionaryForKey:@"myDictionary"];
            NSDictionary *user_id = [userinfo dictionaryForKey:@"user_id"];
            
            
            
//            NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
            NSString *name = user_id[@"user_id"];
            
            [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:@"image/png"];
            
//            NSString *str = [NSString stringWithFormat:@"file:///Applications/XAMPP/xamppfiles/htdocs/OralEduServer/uploadImg/%@.jpg",name];
//            
//            NSDictionary *para=@{@"user_moblie":name,@"user_newurl":str};
//            
//            [HttpTool postWithparamsWithURL:@"Update/UrlUpdate" andParam:para success:^(id responseObject) {
//                NSData *data = [[NSData alloc] initWithData:responseObject];
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                
//                NSLog(@"%@",dic);
//                
//                
//                
//                
//            } failure:^(NSError *error) {
//                NSLog(@"%@",error);
//            }];
//            
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
          
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            
        }];
        
        
        
        
    }else if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]){
        
        self.movieURL = info[UIImagePickerControllerMediaURL];
        
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"changePhotoImage" object:nil userInfo:@{@"image":image}];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)updateDisplay{
    
    if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]){
        
        self.avatarImageView.image = self.image;
        self.avatarImageView.hidden = NO;
        
        
    }
    
}


@end
