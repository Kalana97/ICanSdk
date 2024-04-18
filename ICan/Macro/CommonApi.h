#ifndef Common_h
#define Common_h
#define KSecretHeadImg @"https://oss.icanlk.com/android/icon/icon_private.png"

#define ICANTYPETARGET  @"ICANTYPE"
#define ICANCNTYPETARGET  @"ICANCNTYPE"
///ICan
#ifdef ICANTYPE

#define CHANNELTYPE  @"ICANTYPE"
#if (defined(DEBUG)&&!defined(RELEASE))
static DDLogLevel ddLogLevel = DDLogLevelAll;
#if(ISTESTBED)
//DEBUG TEST BED
#define BASE_URL @"https://chat-api.icanim.com"
#define DomainDownloadUrl  @"https://oss.icanlk.com/system/conf/domain/domain"
#define SOCKET_URL @"wss://chat-api.icanim.com/sock/websocket"
#define kAPNSCerName @"dev"
#define kRSAPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvEh3no7r/FGdgwhcb1fROhUjie7GAXt0Xt15QOlW9IKzvsMT68A1kDmV7CnIUyFT0zNr/1hQdPGO7wKpAmUMW54s2vk8Ty/E/4ue+bP1XQ2uxoACLKWJh4kV4ve2fVVsg75z0wKNBMG5Ps7558ee+f7O5fe31N4XStqerrTpvPvt8qR4dgIyWFBu+oEZnPKJkdrWhI+eySeF/9NL6/v+dNzkkyu9HTPPAowxYrJmEJ/1JX4XILIljUCvMgX4ZsQmrxDN6LRyi93Fw/qYsSh28MKrqcsbYqjJGWsM8HJC9WUyIyMs3wPwFSU2wT2EsKsTDfB5aZ9oVqSZV9m2bNvrhQIDAQAB"
#define CircleBASE_URL @"https://circle-api.icanim.com"
#define C2CBASE_URL @"https://c2c-api.icanim.com"//c2c-api.icanim.com

#else
//DEBUG LIVE BED
#define BASE_URL @"https://service.icanlk.com"
#define DomainDownloadUrl  @"https://oss.icanlk.com/system/conf/domain/domain"
#define SOCKET_URL @"wss://service.icanlk.com/sock/websocket"
#define kAPNSCerName @"dis"
#define kRSAPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvEh3no7r/FGdgwhcb1fROhUjie7GAXt0Xt15QOlW9IKzvsMT68A1kDmV7CnIUyFT0zNr/1hQdPGO7wKpAmUMW54s2vk8Ty/E/4ue+bP1XQ2uxoACLKWJh4kV4ve2fVVsg75z0wKNBMG5Ps7558ee+f7O5fe31N4XStqerrTpvPvt8qR4dgIyWFBu+oEZnPKJkdrWhI+eySeF/9NL6/v+dNzkkyu9HTPPAowxYrJmEJ/1JX4XILIljUCvMgX4ZsQmrxDN6LRyi93Fw/qYsSh28MKrqcsbYqjJGWsM8HJC9WUyIyMs3wPwFSU2wT2EsKsTDfB5aZ9oVqSZV9m2bNvrhQIDAQAB"
#define CircleBASE_URL @"https://cserver.icanlk.com"
#define C2CBASE_URL @"https://c2cservice.icanlk.com"
#endif
#else

//RELEASE
static DDLogLevel ddLogLevel = DDLogLevelOff;
#define BASE_URL @"https://service.icanlk.com"
#define DomainDownloadUrl  @"https://oss.icanlk.com/system/conf/domain/domain"
#define SOCKET_URL @"wss://service.icanlk.com/sock/websocket"
#define kAPNSCerName @"dis"
#define kRSAPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvEh3no7r/FGdgwhcb1fROhUjie7GAXt0Xt15QOlW9IKzvsMT68A1kDmV7CnIUyFT0zNr/1hQdPGO7wKpAmUMW54s2vk8Ty/E/4ue+bP1XQ2uxoACLKWJh4kV4ve2fVVsg75z0wKNBMG5Ps7558ee+f7O5fe31N4XStqerrTpvPvt8qR4dgIyWFBu+oEZnPKJkdrWhI+eySeF/9NL6/v+dNzkkyu9HTPPAowxYrJmEJ/1JX4XILIljUCvMgX4ZsQmrxDN6LRyi93Fw/qYsSh28MKrqcsbYqjJGWsM8HJC9WUyIyMs3wPwFSU2wT2EsKsTDfB5aZ9oVqSZV9m2bNvrhQIDAQAB"
#define CircleBASE_URL @"https://cserver.icanlk.com"
#define C2CBASE_URL @"https://c2cservice.icanlk.com"
#endif
#endif

///ICanCN
#ifdef ICANCNTYPE

#define CHANNELTYPE  @"ICANCNTYPE"
#if (defined(DEBUG)&&!defined(RELEASE))
static DDLogLevel ddLogLevel = DDLogLevelAll;
#if(ISTESTBED)
//DEBUG TEST BED
#define BASE_URL @"https://chat-api.icanim.com"
#define DomainDownloadUrl  @"https://ican-chat.oss-ap-southeast-1.aliyuncs.com/system/conf/domain/domainhchat"
#define SOCKET_URL @"wss://chat-api.icanim.com/sock/websocket"
#define kAPNSCerName @"dev"
#define kRSAPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvEh3no7r/FGdgwhcb1fROhUjie7GAXt0Xt15QOlW9IKzvsMT68A1kDmV7CnIUyFT0zNr/1hQdPGO7wKpAmUMW54s2vk8Ty/E/4ue+bP1XQ2uxoACLKWJh4kV4ve2fVVsg75z0wKNBMG5Ps7558ee+f7O5fe31N4XStqerrTpvPvt8qR4dgIyWFBu+oEZnPKJkdrWhI+eySeF/9NL6/v+dNzkkyu9HTPPAowxYrJmEJ/1JX4XILIljUCvMgX4ZsQmrxDN6LRyi93Fw/qYsSh28MKrqcsbYqjJGWsM8HJC9WUyIyMs3wPwFSU2wT2EsKsTDfB5aZ9oVqSZV9m2bNvrhQIDAQAB"
#define CircleBASE_URL @"https://circle-api.icanim.com"
#define C2CBASE_URL @"https://c2c-api.icanim.com"

#else
//DEBUG LIVE BED
#define BASE_URL @"https://service.icanlk.com"
#define DomainDownloadUrl  @"https://ican-chat.oss-ap-southeast-1.aliyuncs.com/system/conf/domain/domainhchat"
#define SOCKET_URL @"wss://service.icanlk.com/sock/websocket"
#define kAPNSCerName @"dis"
#define kRSAPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvEh3no7r/FGdgwhcb1fROhUjie7GAXt0Xt15QOlW9IKzvsMT68A1kDmV7CnIUyFT0zNr/1hQdPGO7wKpAmUMW54s2vk8Ty/E/4ue+bP1XQ2uxoACLKWJh4kV4ve2fVVsg75z0wKNBMG5Ps7558ee+f7O5fe31N4XStqerrTpvPvt8qR4dgIyWFBu+oEZnPKJkdrWhI+eySeF/9NL6/v+dNzkkyu9HTPPAowxYrJmEJ/1JX4XILIljUCvMgX4ZsQmrxDN6LRyi93Fw/qYsSh28MKrqcsbYqjJGWsM8HJC9WUyIyMs3wPwFSU2wT2EsKsTDfB5aZ9oVqSZV9m2bNvrhQIDAQAB"
#define CircleBASE_URL @"https://cserver.icanlk.com"
#define C2CBASE_URL @"https://c2cservice.icanlk.com"
#endif
#else

//RELEASE
static DDLogLevel ddLogLevel = DDLogLevelOff;
#define BASE_URL @"https://service.icanlk.com"
#define DomainDownloadUrl  @"https://ican-chat.oss-ap-southeast-1.aliyuncs.com/system/conf/domain/domainhchat"
#define SOCKET_URL @"wss://service.icanlk.com/sock/websocket"
#define kAPNSCerName @"dis"
#define kRSAPublicKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvEh3no7r/FGdgwhcb1fROhUjie7GAXt0Xt15QOlW9IKzvsMT68A1kDmV7CnIUyFT0zNr/1hQdPGO7wKpAmUMW54s2vk8Ty/E/4ue+bP1XQ2uxoACLKWJh4kV4ve2fVVsg75z0wKNBMG5Ps7558ee+f7O5fe31N4XStqerrTpvPvt8qR4dgIyWFBu+oEZnPKJkdrWhI+eySeF/9NL6/v+dNzkkyu9HTPPAowxYrJmEJ/1JX4XILIljUCvMgX4ZsQmrxDN6LRyi93Fw/qYsSh28MKrqcsbYqjJGWsM8HJC9WUyIyMs3wPwFSU2wT2EsKsTDfB5aZ9oVqSZV9m2bNvrhQIDAQAB"
#define CircleBASE_URL @"https://cserver.icanlk.com"
#define C2CBASE_URL @"https://c2cservice.icanlk.com"
#endif
#endif

#endif /* Common_h */

