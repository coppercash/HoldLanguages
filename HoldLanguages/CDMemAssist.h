#if __has_feature(objc_arc)
#define SafeRetain(x) (x)
#define SafeRelease(x)
#define SafeMemberRelease(x) ((x) = nil)
#define SafeSuperDealloc()
#else
#define SafeRetain(x) ([(x) retain])
#define SafeRelease(x) ([(x) release])
#define SafeMemberRelease(x) ([(x) release], (x) = nil)
#define SafeSuperDealloc() ([super dealloc])
#endif
