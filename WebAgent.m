//
//  WebAgent.m
//  WebServer
//
//  Created by tjufe on 16/7/22.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import "WebAgent.h"
#import "APIClient.h"
@implementation WebAgent

//上传个人信息
+(void)userid:(NSString *)user_id
   usernickname:(NSString *)user_nickname
        usersex:(NSString *)user_sex
      userbirth:(NSString *)user_birth
   userdistrict:(NSString *)user_district
  usersignature:(NSString *)user_signature
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"newuser_id":user_id,
                           @"newuser_nickname":user_nickname,
                           @"newuser_sex":user_sex,
                           @"newuser_birth":user_birth,
                           @"newuser_district":user_district,
                           @"newuser_signature":user_signature};
    [[APIClient sharedClient] POST:@"User/upload/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

//下拉个人信息
+(void)userid:(NSString *)user_id
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"User/edit/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];

}


//Protocol
+(void)version_numProtocol:(NSString *)version_num
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"version_num":version_num};
    
    [[APIClient sharedClient] POST:@"User/loginProtocol/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}




//About
+(void)version_numAbout:(NSString *)version_num
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"version_num":version_num};
    
    
    [[APIClient sharedClient] POST:@"User/loginAbout/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//查询是否有等候的译员
+(void)findingIsWaitingWithStringOfLanguage:(NSString *)language
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"user_language":language};
    
    [[APIClient sharedClient] POST:@"User/loginHelp/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//加入等候队列
+(void)addIntoWaitingQueue:(NSString *)user_id
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"user_id":user_id};
    
    [[APIClient sharedClient] POST:@"QuickTrans/addintoqueue/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//移除等候队列
+(void)removeFromWaitingQueue:(NSString *)user_id
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"user_id":user_id};
    
    [[APIClient sharedClient] POST:@"QuickTrans/removefromqueue/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//查询等候队列
+(void)selectWaitingQueue:(NSString *)user_language
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"user_language":user_language};
    
    [[APIClient sharedClient] POST:@"QuickTrans/selectwaitingqueue/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}


//Help
+(void)user_id:(NSString *)user_id
user_feedbackinfo:(NSString *)user_feedbackinfo
feedbackinfo_time:(NSString *)feedbackinfo_time
    user_phone:(NSString *)user_phone
    user_email:(NSString *)user_email
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"user_id":user_id,
                           @"user_feedbackinfo":user_feedbackinfo,
                           @"feedbackinfo_time":feedbackinfo_time,
                           @"user_phone":user_phone,
                           @"user_email":user_email};
    
    [[APIClient sharedClient] POST:@"User/loginHelp/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//lxx
+(void)userGetInfo:(NSString *)userId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":userId};
    
    [[APIClient sharedClient] POST:@"User/getUserInfo/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

//lzy
//登录
+(void)translator_id:(NSString *)translator_id
         valuator_id:(NSString *)valuator_id
   evaluate_infostar:(NSString *)evaluate_infostar
   evaluate_infotext:(NSString *)evaluate_infotext
       translation_id:(NSString *)translation_id
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"translator_id":translator_id,
                           @"valuator_id":valuator_id,
                           @"evaluate_infostar":evaluate_infostar,
                           @"evaluate_infotext":evaluate_infotext,
                           @"translation_id":translation_id
                           };
    
    [[APIClient sharedClient] POST:@"User/evaluate/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

+(void)user_id:(NSString *)user_id
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"User/edit/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
//验证登录
+(void)userLoginState:(NSString *)userID
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"user_id":userID};
    
    [[APIClient sharedClient] POST:@"User/userloginstate/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//登录
+(void)userLogin:(NSString *)userPhone
         userPsw:(NSString *)userPsw
         
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"user_phone":userPhone,
                           @"user_password":userPsw};
    
    [[APIClient sharedClient] POST:@"User/login/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
+(void)userLogout:(NSString *)userID
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"user_id":userID};
    
    [[APIClient sharedClient] POST:@"User/user_logout/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}
//注册
+(void)userPhone:(NSString *)userPhone
         userPsw:(NSString *)userPsw
        userName:(NSString *)userName
          userID:(NSString *)userID
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_phone":userPhone,
                           @"user_password":userPsw,
                           @"user_name":userName,
                           @"user_id":userID};
    
    [[APIClient sharedClient] POST:@"User/user_register/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
//找回密码
+(void)userPhone:(NSString *)userPhone
         userPsw:(NSString *)userPsw
          userID:(NSString *)userID
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"user_phone":userPhone,
                           @"user_password":userPsw,
                           @"user_id":userID};
    
    [[APIClient sharedClient] POST:@"User/user_findKey/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//检验此手机号是否注册
+(void)userPhone:(NSString *)userPhone
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"user_phone":userPhone};
    
    [[APIClient sharedClient] POST:@"User/login/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//选择语言
+(void)selectLanguage:(NSString *)languageKind
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"language_kind":languageKind};
    
    [[APIClient sharedClient] POST:@"User/selectLanguage/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//轮播图图片
+(void)addScrollViewImage:(NSString *)turnPictureID
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"turnpicture_id":turnPictureID};
    [[APIClient sharedClient] POST:@"User/addScrollViewImage/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
//更改邮箱
+(void)userId:(NSString *)user_id userEmail:(NSString *)user_email accountstate:(NSString *)account_state success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *dict = @{@"user_id":user_id,
                           @"user_email":user_email,
                           @"emailState":account_state};
    
    [[APIClient sharedClient] POST:@"User/changeEmail/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];

}

//账号保护状态
+(void)userId:(NSString *)user_id
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"User/accountState" parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

//查找译员所会语种,匹配译员，返回所有译员ID，（发送推送用）
+(void)matchTranslatorWithchooseLanguage:(NSString *)choose_language
                                 user_id:(NSString *)user_id
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"choose_language":choose_language,
                           @"user_id":user_id};
    [[APIClient sharedClient] POST:@"QuickTrans/matchTranslator" parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

//查询用户口语即时请求状态。（匹配译员用）
+(void)interpreterStateWithuserId:(NSString *)user_id
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"QuickTrans/interpreterState" parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//将译者状态置为require
+(void)interpreterRequireStateWithuserId:(NSString *)user_id
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"QuickTrans/interpreterRequireState" parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


//口语即时，发送远程推送APNS
+(void)sendRemoteNotificationsWithuseId:(NSString *)user_id
                        WithsendMessage:(NSString *)send_message
                       WithlanguageCatgory:(NSString *)language_catgory
                          WithpayNumber:(NSString *)pay_number
                           WithSenderID:(NSString *)sender_id
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id,
                           @"sender_id":sender_id,
                           @"send_message":send_message,
                           @"language_catgory":language_catgory,
                           @"pay_number":pay_number};
    [[APIClient sharedClient] POST:@"Test/sendRemoteNotifications" parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}
//
+(void)userIdentity:(NSString *)userIdentity
       userLanguage:(NSString *)userLanguage
             userID:(NSString *)userID
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"user_identity":userIdentity,
                           @"user_language":userLanguage,
                           @"user_id":userID};
    
    [[APIClient sharedClient] POST:@"User/user_interpreter/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

//勿扰模式
+(void)wuraomoshiWithuseId:(NSString *)user_id
       Withtranslatorallow:(NSString *)translator_allow
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id,
                           @"translator_allow":translator_allow};
    [[APIClient sharedClient] POST:@"QuickTrans/wuraomoshi" parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//发布悬赏
+(void)sendRewardRewardID:(NSString *)rewardID
              rewardTitle:(NSString *)rewardTitle
               rewardText:(NSString *)rewardText
                rewardUrl:(NSString *)rewardUrl
              rewardMoney:(NSString *)rewardMoney
           rewardLanguage:(NSString *)language
                rewardtag:(NSString *)rewardtag
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure

{
    if (rewardtag == nil) {
        rewardtag = @"";
    }
    NSDictionary *dict = @{@"user_id":rewardID,
                           @"reward_title":rewardTitle,
                           @"reward_text":rewardText,
                           @"reward_url":rewardUrl,
                           @"reward_money":rewardMoney,
                           @"language":language,
                           @"reward_tag":rewardtag};
    
    [[APIClient sharedClient] POST:@"Reward/reward_info_add_operation/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
//获取热门标签
+(void)getLabelInfo:(NSString *)labelId
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"label_id":labelId};
    
    [[APIClient sharedClient] POST:@"Reward/getLabel_info/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}
//悬赏大厅
+(void)proceed_state:(NSString *)proceed_state
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"proceed_state":proceed_state};
    
    
    [[APIClient sharedClient] POST:@"Reward/AllRewardInformation/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}
//我的悬赏
+(void)myRewardrewardID:(NSString *)rewardID
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dict = @{@"rewarder_id":rewardID};
    
    
    [[APIClient sharedClient] POST:@"Reward/myReward/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}






//悬赏详情
+(void)rewardDetial:(NSString *)rewardId
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dict = @{@"reward_id":rewardId};
    
    [[APIClient sharedClient] POST:@"Reward/getinfo" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
    
}
//提交回答
+(void)user_id:(NSString *)user_id
//       user_id:(NSString *)user_id
   reward_text:(NSString *)reward_text
   answer_time:(NSString *)answer_time
       success:(void(^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id,
                           @"user_id":user_id,
                           @"answer_time":answer_time,
                           @"reward_text":reward_text};
    [[APIClient sharedClient] POST:@"Reward/upLoad/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}
//identifyuser_id
+(void)identifyuser_id:(NSString *)user_id
       success:(void(^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"QuickTrans/identify/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

//翻译人数
+(void)returnPeopleReward:(NSString *)reward_id
                  success:(void(^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"reward_id":reward_id};
    [[APIClient sharedClient] POST:@"Reward/return_people/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}
//游币剩余
+(void)restMoenyUser_id:(NSString *)user_id
                success:(void(^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"Reward/rest_money/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}
//返回评价内容
+(void)returnTextReward_id:(NSString *)reward_id
                   user_id:(NSString *)user_id
                   success:(void(^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"user_id":user_id};
    [[APIClient sharedClient] POST:@"Reward/returntext/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

//提交回答
+(void)uploadreward_id:(NSString *)reward_id
               user_id:(NSString *)user_id
           reward_text:(NSString *)reward_text
           answer_time:(NSString *)answer_time
               success:(void(^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    NSDictionary *dict = @{@"reward_id":reward_id,
                           @"user_id":user_id,
                           @"answer_time":answer_time,
                           @"reward_text":reward_text};
    [[APIClient sharedClient] POST:@"Reward/upLoad/" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
