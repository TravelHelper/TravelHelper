//
//  WebAgent.h
//  WebServer
//
//  Created by tjufe on 16/7/22.
//  Copyright © 2016年 tjufe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAgent : NSObject
+(void)selectAcceptaccept_id:(NSString *)accept_id
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

+(void)custom_id:(NSString *)custom_id
           state:(NSString *)state
       accept_id:(NSString *)accept_id
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;

+(void)uploaduser_id:(NSString *)user_id
            language:(NSString *)language
               scene:(NSString *)scene
             content:(NSString *)content
         custom_time:(NSString *)custom_time
            duration:(NSString *)duration
         offer_money:(NSString *)offer_money
               state:(NSString *)state
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;





+(void)userGetInfo:(NSString *)userId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


+(void)selectLoadDatesuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

+(void)custom_id:(NSString *)custom_id
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;

+(void)customtranslate_userid:(NSString *)user_id
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

+(void)delectByCustom_id:(NSString *)custom_id
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

+(void)userid:(NSString *)user_id
 usernickname:(NSString *)user_nickname
      usersex:(NSString *)user_sex
    userbirth:(NSString *)user_birth
 userdistrict:(NSString *)user_district
usersignature:(NSString *)user_signature
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;

+(void)userid:(NSString *)user_id
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;

//Protocol
+(void)version_numProtocol:(NSString *)version_num
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

//About
+(void)version_numAbout:(NSString *)version_num
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

//Help
+(void)user_id:(NSString *)user_id
user_feedbackinfo:(NSString *)user_feedbackinfo
feedbackinfo_time:(NSString *)feedbackinfo_time
    user_phone:(NSString *)user_phone
    user_email:(NSString *)user_email
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

//lxx
+(void)userGetInfo:(NSString *)userId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

//lzy
+(void)translator_id:(NSString *)translator_id
         valuator_id:(NSString *)valuator_id
   evaluate_infostar:(NSString *)evaluate_infostar
   evaluate_infotext:(NSString *)evaluate_infotext
      translation_id:(NSString *)translation_id
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

+(void)user_id:(NSString *)user_id
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;
//验证登录
+(void)userLoginState:(NSString *)userID

              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
//登陆
+(void)userLogin:(NSString *)userPhone
         userPsw:(NSString *)userPsw
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;
//退出登录
+(void)userLogout:(NSString *)userID
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure;
//注册
+(void)userPhone:(NSString *)userPhone
         userPsw:(NSString *)userPsw
        userName:(NSString *)userName
          userID:(NSString *)userID
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;
//找回密码
+(void)userPhone:(NSString *)userPhone
         userPsw:(NSString *)userPsw
          userID:(NSString *)userID
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;
//检验是否已经注册
+(void)userPhone:(NSString *)userPhone
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;
//选择语言
+(void)selectLanguage:(NSString *)languageKind
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
//轮播图图片
+(void)addScrollViewImage:(NSString *)turnPictureID
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
//更改邮箱
+(void)userId:(NSString *)user_id userEmail:(NSString *)user_email accountstate:(NSString *)account_state success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;

//账号保护状态
+(void)userId:(NSString *)user_id success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;


//查找译员所会语种,匹配译员，返回所有译员ID，（发送推送用）
+(void)matchTranslatorWithchooseLanguage:(NSString *)choose_language
                                 user_id:(NSString *)user_id
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
//查询用户口语即时请求状态。（匹配译员用）
+(void)interpreterStateWithuserId:(NSString *)user_id
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

//将译者状态置为require
+(void)interpreterRequireStateWithuserId:(NSString *)user_id
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;

//口语即时，发送远程推送APNS
+(void)sendRemoteNotificationsWithuseId:(NSString *)user_id
                        WithsendMessage:(NSString *)send_message
                    WithlanguageCatgory:(NSString *)language_catgory
                          WithpayNumber:(NSString *)pay_number
                           WithSenderID:(NSString *)sender_id
                          WithMessionID:(NSString *)ID
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
//语言
+(void)userIdentity:(NSString *)userIdentity
       userLanguage:(NSString *)userLanguage
             userID:(NSString *)userID
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
//加入等候队列
+(void)addIntoWaitingQueue:(NSString *)user_id
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
//移除等候队列
+(void)removeFromWaitingQueue:(NSString *)user_id
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
//查询等候队列
+(void)selectTranslator:(NSString *)user_language
                  user_id:(NSString *)user_id
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

//勿扰模式
+(void)wuraomoshiWithuseId:(NSString *)user_id
       Withtranslatorallow:(NSString *)translator_allow
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
//发布悬赏
+(void)sendRewardRewardID:(NSString *)rewardID
               rewarderID:(NSString *)rewarderID
              rewardTitle:(NSString *)rewardTitle
               rewardText:(NSString *)rewardText
                rewardUrl:(NSString *)rewardUrl
              rewardMoney:(NSString *)rewardMoney
           rewardLanguage:(NSString *)language
                rewardtag:(NSString *)rewardtag
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

//获取热门标签
+(void)getLabelInfo:(NSString *)labelId
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
//悬赏大厅
+(void)getRewardHallInfo:(NSString *)user_id
             AndLanguage:(NSString *)language
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
+(void)language:(NSString *)language
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;
+(void)money:(NSString *)money
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;
+(void)time:(NSString *)time
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;
+(void)searchContent:(NSString *)searchContent
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

//悬赏详情
+(void)rewardDetial:(NSString *)rewardId
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
//我的悬赏
+(void)myRewardrewardID:(NSString *)user_id
            AndLanguage:(NSString *)language
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
//提交回答
+(void)user_id:(NSString *)user_id
//       user_id:(NSString *)user_id
   reward_text:(NSString *)reward_text
   answer_time:(NSString *)answer_time
       success:(void(^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

//判断身份，是否进入评论页
+(void)identifyuser_id:(NSString *)user_id
               success:(void(^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

//翻译人数
+(void)returnPeopleReward:(NSString *)reward_id
                  success:(void(^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
//剩余游币
+(void)restMoenyUser_id:(NSString *)user_id
                success:(void(^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
//返回评价内容
+(void)returnTextReward_id:(NSString *)reward_id
                   user_id:(NSString *)user_id
                   success:(void(^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
//提交回答
+(void)uploadreward_id:(NSString *)reward_id
               user_id:(NSString *)user_id
           reward_text:(NSString *)reward_text
           answer_time:(NSString *)answer_time
               success:(void(^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

+(void)creatUserList:(NSString *)now_time
          andUser_id:(NSString *)user_id
        WithLanguage:(NSString *)spoken_language
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
+(void)UpdateUserListWithID:(NSString *)ID
                andAnswerId:(NSString *)answer_id
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;
+(void)UpdateUserMessageWithID:(NSString *)ID
                       andStar:(NSString *)star
                      andMoney:(NSString *)money
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


+(void)UpdateUsertipoffWithMseeageId:(NSString *)messageId
                        TranslatorId:(NSString *)translatorId
                          reporterId:(NSString *)reporter_id
                         report_text:(NSString *)report_text
                         report_time:(NSString *)report_time
                             success:(void(^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;



+(void)getHaveFunInfo:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

+(void)UpdateTranslatorMessageCount:(NSString *)ID
                andTranslator_price:(NSString *)translator_price
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;

+(void)UpdateUserMessageCount:(NSString *)ID
                andUser_price:(NSString *)user_price
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;
+(void)getuserTranslateState:(NSString *)userID
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

+(void)getFrontImagesuccess:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

//+(void)UpdateUserMessageCount:(NSString *)ID
//                andUser_price:(NSString *)user_price
//                      success:(void (^)(id responseObject))success
//                      failure:(void (^)(NSError *error))failure;

//上传回答
+(void)upLoadMyChoose:(NSString *)answer_id
          AndRewardId:(NSString *)reward_id
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

+(void)updateUserLoginState:(NSString *)userID
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;


+(void)interpreterStateWithuserId:(NSString *)user_id
                     andmessionID:(NSString *)messionID
                      andAnswerID:(NSString *)answer_id
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

+(void)stopFindingTranslator:(NSString *)user_id
                   missionID:(NSString *)mission_id
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

+(void)getMissionInfo:(NSString *)mission_id
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

+(void)selectCancelState:(NSString *)mission_id
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

+(void)addTranslatorInfo:(NSString *)user_id
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

+(void)exchangePushCount:(NSString *)user_id
                AndState:(NSString *)state
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
+(void)getSwitchState:(NSString *)user_id
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;

+(void)changeTranslatorBusy:(NSString *)user_id
                      state:(NSString *)state
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

+(void)updateUserLastTime:(NSString *)user_id
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

+(void)getTargetLoginState:(NSString *)user_id
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

@end
