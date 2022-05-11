#import <Foundation/Foundation.h>
#import <Consumer.hpp>
#import <WebRTC/RTCMediaStreamTrack.h>
#import "ConsumerWrapper.hpp"
#import "ConsumerListenerAdapter.hpp"
#import "ConsumerListenerAdapterDelegate.h"
#import "ConsumerWrapperDelegate.h"
#import "../MediasoupClientError/MediasoupClientErrorHandler.h"


@interface ConsumerWrapper () <ConsumerListenerAdapterDelegate> {
	mediasoupclient::Consumer *_consumer;
	ConsumerListenerAdapter *_listenerAdapter;
}
@property(nonatomic, nonnull, readwrite) RTCMediaStreamTrack *track;
@end


@implementation ConsumerWrapper

- (instancetype)initWithConsumer:(mediasoupclient::Consumer *_Nonnull)consumer
	track:(RTCMediaStreamTrack *_Nonnull)track
	listenerAdapter:(ConsumerListenerAdapter *_Nonnull)listenerAdapter {

	self = [super init];

	if (self != nil) {
		_consumer = consumer;
		_listenerAdapter = listenerAdapter;
		_listenerAdapter->delegate = self;

		self.track = track;
	}

	return self;
}

- (void)dealloc {
	delete _consumer;
	// TODO: delete _listenerAdapter
}

#pragma mark - Public methods

- (NSString *_Nonnull)id {
	return [NSString stringWithUTF8String:_consumer->GetId().c_str()];
}

- (NSString *_Nonnull)producerId {
	return [NSString stringWithUTF8String:_consumer->GetProducerId().c_str()];
}

- (NSString *_Nonnull)localId {
	return [NSString stringWithUTF8String:_consumer->GetLocalId().c_str()];
}

- (BOOL)closed {
	return _consumer->IsClosed() == true;
}

- (BOOL)paused {
	return _consumer->IsPaused() == true;
}

- (NSString *_Nonnull)kind {
	return [NSString stringWithUTF8String:_consumer->GetKind().c_str()];
}

//- (UInt8)maxSpatialLayer {
//	return _producer->GetMaxSpatialLayer();
//}

- (NSString *_Nonnull)appData {
	return [NSString stringWithUTF8String:_consumer->GetAppData().dump().c_str()];
}

- (NSString *_Nonnull)rtpParameters {
	return [NSString stringWithUTF8String:_consumer->GetRtpParameters().dump().c_str()];
}

- (void)pause {
	_consumer->Pause();
}

- (void)resume {
	_consumer->Resume();
}

- (void)close {
	_consumer->Close();
}

//- (void)setMaxSpatialLayer:(UInt8)layer
//	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
//	__attribute__((swift_error(nonnull_error))) {
//
//	mediasoupTry(^{
//		self->_producer->SetMaxSpatialLayer(layer);
//	}, error);
//}

//- (void)replaceTrack:(RTCMediaStreamTrack *)track
//	error:(out NSError *__autoreleasing _Nullable *_Nullable)error
//	__attribute__((swift_error(nonnull_error))) {
//
//	mediasoupTry(^{
//		// RTCMediaStreamTrack `hash` returns pointer to native track object.
//		auto mediaStreamTrack = (webrtc::MediaStreamTrackInterface *)[track hash];
//		self->_producer->ReplaceTrack(mediaStreamTrack);
//		self.track = track;
//	}, error);
//}

- (NSString *_Nullable)getStatsWithError:(out NSError *__autoreleasing _Nullable *_Nullable)error {
	return nil;
}

#pragma mark - ProducerListenerAdapterDelegate methods

- (void)onTransportClose:(ConsumerListenerAdapter *_Nonnull)adapter {
	if (adapter != _listenerAdapter) {
		return;
	}

	[self.delegate onTransportClose:self];
}

@end
