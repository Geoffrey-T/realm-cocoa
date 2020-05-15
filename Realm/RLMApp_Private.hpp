////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import <Realm/RLMApp.h>
#import <memory>
#import "sync/app.hpp"

@interface RLMAppConfiguration()

- (realm::app::App::Config&)config;

- (void)setAppId:(nonnull NSString *)appId;

@end

@interface RLMApp ()
- (std::shared_ptr<realm::app::App>)_realmApp;

- (void)handleResponse:(realm::util::Optional<realm::app::AppError>)error
            completion:(nonnull RLMOptionalErrorBlock)completion;

+ (nonnull instancetype)appWithAppId:(nonnull NSString *)appId
                       configuration:(nonnull RLMAppConfiguration *)configuration
                       rootDirectory:(nullable NSURL *)rootDirectory;
@end

NSError * _Nonnull RLMAppErrorToNSError(realm::app::AppError const& appError);
