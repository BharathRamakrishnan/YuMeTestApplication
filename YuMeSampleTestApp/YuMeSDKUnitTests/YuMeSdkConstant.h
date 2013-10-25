//
//  YuMeSdkConstant.h
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/23/13.
//  Copyright (c) 2013 Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#ifndef YuMeiOSTestApp_YuMeSdkConstant_h
#define YuMeiOSTestApp_YuMeSdkConstant_h

#define UNIT_TEST_VERSION @"2.0.0.6"

#define kUSE_OWN_VIDEOPLAYER  0

#define kTEST_REPORT 1

#define kTIME_OUT 120

#define NON_200_OK_PL @""

#define EMPTY_INVALID_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/iempty_200/"

#define EMPTY_VALID_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vempty_200/"

#define FILLED_INVALID_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/ifilled_200/"

#define FILLED_MISSING_ASSETS_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/m_200/"

#define VALID_200_OK_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/v_200/"

#define VALID_200_RMEDIA_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/v_200_media/"

#define VALID_FILLED_404_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/v_404/"

#define VALID_FILLED_REDIRECT_VIDEO_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/rvideo/"

#define VALID_FILLED_REDIRECT_IMAGE_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/rimage/"

#define VALID_FILLED_REDIRECT_OVERLAY_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/roverlay/"

#define VALID_FILLED_REDIRECT_TREACKERS_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/roverlay/"  // needs to update

#define VALID_FILLED_MISSING_EXPIRATION_TIME_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/v_200expiry/"

#define VALID_EMPTY_MISSING_PREFETCH_CALLBACK_INTERVAL_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vempty_200callback/"

#define VALID_FILLED_MISSING_CREATIVE_RETRY_INTERVAL_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/v_404retry/"

#define VALID_FILLED_MISSING_CREATIVE_RETRY_ATTEMPTS_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/v_404attempt/"

#define VALID_FILLED_MISSING_CB_ACTIVE_TIME_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/icbtime/"

#define VALID_FILLED_DIFF_SIZE_PL @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/diff_size/" // needs to update


#define EMPTY_CALL_BACK_INTERVAL_MISSING @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/empty_call_back_interval_missing"

#define EMPTY_UNFILLED_CALL_BACK_INTERVAL_MISSING @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/empty_unfilled_call_back_interval_missing"

#define EMPTY_VALID @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/empty_valid"

#define FILLED_CB_NEGATIVE @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_cb_negative"

#define FILLED_CREATIVE_404 @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_creative_404"

#define FILLED_CREATIVE_RETRY_ATTEMPTS0 @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_creative_retry_attempts0"

#define FILLED_CREATIVE_RETRY_INTERVAL_MISSING @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_creative_retry_interval_missing"

#define FILLED_CREATIVE_RETRY_MISSING @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_creative_retry_missing"

#define FILLED_CREATIVE_RETRY0 @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_creative_retry0"

#define FILLED_CREATIVE_WITH_ONE_REQUIRES @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_creative_with_one_requires"

#define FILLED_EXPIRATION0 @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_expiration0"

#define FILLED_NOCREATIVES @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_nocreatives"

#define FILLED_WITHOUT_CREATIVES @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_without_creatives"

#define FILLED_WITHOUT_PREFETCH @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/filled_without_prefetch"

#define INVALID_EMPTY @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/invalid_empty"

#define INVALID_UNFILLED_PREFETCH @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/invalid_unfilled_prefetch"

#define PLAIN_IMAGE_404_CREATIVE @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/plain_image_404_creative"

#define PLAIN_IMAGE_MULTIPLE_CREATIVES @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/plain_image_multiple_creatives"

#define PLAIN_IMAGE_REDIRECTION @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/plain_image_redirection"

#define PLAIN_IMAGE_WITH_DURATION @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/plain_image_with_duration"

#define PLAIN_IMAGE_WITH_DURATION_QA @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/plain_image_with_duration_qa"

#define PLAIN_IMAGE_WITHOUT_DURATION @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/plain_image_without_duration"

#define PREAD_SURVEY @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/preAd_survey"

#define SIZE @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/size"

#define VALID_EXPIRATION_TIME_MISSING @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/valid_expiration_time_missing"

#define VALID_WITHOUT_IMPRESSION @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/valid_without_impression"

#define VALID_ZINDEX @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/valid_zindex"

#define VIDEO_WITHOUT_IMPRESSION @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vast2xmlerror/video_without_impression"


#define EMPTY_NO_CREATIVE @"http://download.yumenetworks.com/yume/hariharan/visnu/vpaid/error/" //1. empty_response, xml feed contains no creative:

#define EMPTY_NO_CHILDREN  @"http://download.yumenetworks.com/yume/Maheswaran/utest/vpaid/nochildren/" //2. empty_response, xml feed contains no children:

#define EMPTY_NO_ADNODE @"http://download.yumenetworks.com/yume/Maheswaran/utest/vpaid/noadnode/"   //3. empty_response, xml feed contains no ad node:

#define XML_MALFORMED   @"http://download.yumenetworks.com/yume/Maheswaran/utest/vpaid/malformed/" //4. other, xml feed malformed:

#define EMPTY_FEED  @"http://download.yumenetworks.com/yume/Maheswaran/utest/vpaid/emptyresponse/"  //5. empty_response, xml feed empty :

#define TRACKERS_EXCEEDED @"http://download.yumenetworks.com/yume/Maheswaran/utest/vpaid/trackersexceeded/" //6. trackers_exceeded, exceeded maximum trackers : Configure a tag which exceeds the trackers which is mentioned in the network admin eg: network admin:3 but the xml feed returns 5 trackers for each quartile trackers Tag to be used:

//---------------Image-------------------

#define IMAGE_PL @"http://172.18.4.105/VAST_playlist/VAST_image_pre-roll_playlist.xml" //7. Image preroll Playlist

#define IMAGE_PF_PL @"http://172.18.4.105/VAST_playlist/VAST_image_pre-roll_prefetch_playlist.xml" // 8. Image preroll prefetch Playlist

#define IMAGE_STREAMING @"http://172.18.4.105/VAST_playlist/VAST_image_streaming_pre-roll_playlist.xml" //9. Image preroll steaming Playlist - Discard playlist if it is in prefetch mode

#define RTMP @"http://172.18.4.105/VAST_playlist/VAST video_rtmp_playlist.xml" // 19. Playlist contains RTMP video creative - invalid playlist

#define FLV @"http://172.18.4.105/VAST_playlist/VAST video_flv_playlist.xml" // 20. Playlist contains flv video creative - invalid playlist

//------------VPAID------------------------
#define VPAID @"http://172.18.4.105/VAST_playlist/VAST_vpaid_playlist.xml" //21. Playlist contains VPAID video creative - invalid playlist

#define VPAID_EMPTY @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vpaid/emptyresponse/"

#define VPAID_MALFORMED @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vpaid/malformed/"

#define VPAID_NOADNODE @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vpaid/noadnode/"

#define VPAID_NOCHILDREN @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vpaid/nochildren/"

#define VPAID_TRACKERSEXCEED @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/vpaid/trackersexceeded/"

//-------------Wrapper-----------------
#define WRAPPER_VALID @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/wrapper/valid/" // wrapper playlist.

#define WRAPPER_RETRY @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/wrapper/retry/"   // wrapper retry playlist.

#define WRAPPER_MAX @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/wrapper/limitexceed/"   // max wrapper playlist.

#define WRAPPER_MAX_TRACKERS_EXCEED @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/wrapper/trackerexceed/"

#define WRAPPER_RETRY_EXCEED @"http://download.yumenetworks.com/yume/demo/Maheswaran/utest/wrapper/retryexceed/"


//----------------InLine----------------
#define INLINE_2AD @"http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist-Inline-2Ads.xml" // 25. Inline 2 ad playlist

#define PF_RETRY_ASSETS @"http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist_pf_asset_retry.xml" // 26. Prefetch asset retry playlist

#define PF_NO_ASSETS @"http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist_pf_no_assets.xml" // 27. Prefetch no assets

#define PF_NO_CLICKTAG @"http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist_pf_no_clicktag.xml" // 28. Prefetch no clicktag

#define INLINE_UNLIMITED_TRACKERS @"http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist-unlimited-trackers-inline.xml" // 29. Inline unlimited trackers

#define INLINE_SINGLE_SEQUENCE @"http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist_single_sequence.xml" // 30. Inline single sequence
                                                                                    
#define INLINE_NO_SEQUENCE  @"http://172.18.4.105/VAST_playlist/dynamic_postroll_playlist-no-sequence.xml" // 32. Inline no sequence

#define INLINE_NONLINEAR @"http://172.18.4.105/VAST_playlist/vast_nonlinear_with_multiple_nonlinear.xml" //33. Inline NonLinear with multiple NonLinear ads

/*
34. Inline, linear and nonlinear with multiple sequence
http://172.18.4.105/VAST_playlist/vast_linear_and_nonlinear_with_sequence.xml
                                                                                    
35. Inline, linear with only one streaming asset
http://172.18.4.105/VAST_playlist/vast_linear_with_only_streaming_asset.xml
                                                                                    
36. Inline, Non linear with and with out seq id
http://172.18.4.105/VAST_playlist/nonlinear_with_and_without_seq_cb.xml
                                                                                    
37. Inline, Non linear with multiple companion banner
http://172.18.4.105/VAST_playlist/vast_Nonlinear_multiple_companions.xml
                                                                                    
38. Inline, Non linear with multiple non linear ada and multiple companion
http://172.18.4.105/VAST_playlist/vast_nonlinear_with_multiple_nonlinear_multiple_companions.xml
                                                                                    
39. Wrapper, companion in wrapper
http://172.18.4.105/VAST_playlist/vast_wrapper_linear_with_companion_in_wrapper .xml
                                                                                    
40. Inline, Linear with sequence and cb sequence
http://172.18.4.105/VAST_playlist/linear_with_seq_cb.xml
                                                                                    
41. Inline, VPAID with companion
http://172.18.4.105/VAST_playlist/vast_linear_vpaid_iframe_companion.xml
                                                                                    
42. Inline, Linear with multiple sequence and cb
http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist_Inline_multiple_sequence.xml
                                                                                    
43. Inline, Linear, non linear with and with out sequence id
http://172.18.4.105/VAST_playlist/linear_nonlinear_with_and_without_seq_cb.xml
                                                                                    
44. Inline, linear vpaid with ad parameters
http://172.18.4.105/VAST_playlist/vast_linear_vpaid_with_ad_parameters.xml
                                                                                    
45. Inline, Linear with 302 assets
http://172.18.4.105/VAST_playlist/vast_linear_with_302_asset.xml

46. Empty prefetch playlist
http://172.18.4.105/VAST_playlist/VAST_empty_prefetch_playlist.xml

47. Empty playlist
http://172.18.4.105/VAST_playlist/VAST_empty_dynamic_preroll_playlist.xml

48. Wrapper, Max tracker
http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist-max-tracker.xml

49. Inline, Linear vpiad with no trackers
http://172.18.4.105/VAST_playlist/vast_linear_vpaid_no_trackers.xml

50. Inline, Linear with cb and different sequence
http://172.18.4.105/VAST_playlist/vast_linear_with_companion_and_sequence_different_id.xml

51. Inline, Linear with cb and sequence, contains both streaming and progressive
http://172.18.4.105/VAST_playlist/vast_linear_with_companion_and_sequence_flv_http_rtmp.xml

52. Inline, Linear with HTML cb
http://172.18.4.105/VAST_playlist/vast_linear_with_html_companion.xml

53. Inline, Linear with iframe and static cb
http://172.18.4.105/VAST_playlist/vast_linear_with_iframe_and_static_companion.xml

54. Inline, Linear with multiple cb
http://172.18.4.105/VAST_playlist/vast_linear_with_multiple_companion.xml

55. Inline, Linear with mulitple cb and with out mp4 creative
http://172.18.4.105/VAST_playlist/vast_linear_with_multiple_companion_2_without_mp4.xml

56. Inline, Linear with multiple cb
http://172.18.4.105/VAST_playlist/vast_linear_with_multiple_companion_2.xml

57. Inline, Linear with progressive and streaming assets
http://172.18.4.105/VAST_playlist/vast_linear_with_progressive_and_streaming_asset.xml

58. Inline, Linear without cb
http://172.18.4.105/VAST_playlist/vast_linear_without_companion.xml

59. Inline, Non Linear - multiple ads
http://172.18.4.105/VAST_playlist/vast_Nonlinear_multiple_ads.xml

60. Inline, Multiple image creative with sequence
http://172.18.4.105/VAST_playlist/dynamic_postroll_playlist_image_with_sequence.xml

61. Wrapper playlist
http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist_wrapper.xml

62. wrapper, inline image sequence prefetch
http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist.xml

63. Inline, inline image sequence prefetch
http://172.18.4.105/VAST_playlist/dynamic_preroll_playlist_Inline_image_sequence_prefetch.xml

64. Inline, video preroll macro playlist
http://172.18.4.105/VAST_playlist/VAST_video_pre-roll_macro_playlist.xml

65. wrapper,  video preroll macro playlist
http://172.18.4.105/VAST_playlist/VAST_video_wrapper_macro_playlist.xml
*/


#define DOMAIN_ID @"704oIaHzpGu"

static YuMeInterface *pYuMeTestInterface;

static VideoPlayerController *videoController;

static YuMeSDKInterface *yumeSDK;

static NSError *pError;

static NSMutableArray *resultArray;


#endif
