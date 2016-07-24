//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "ModelsAssembly.h"
#import "ExchangeModel.h"
#import "AccountModel.h"
#import "ExchangeViewController.h"
#import "ExchangeService.h"


@implementation ModelsAssembly {

}

#pragma mark - Models
- (ExchangeModel *)exchangeModel {
    return [TyphoonDefinition withClass:[ExchangeModel class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithAccountModel:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self accountModel]];
        }];
        [definition injectProperty:@selector(exchangeService) with:[self exchangeService]];
    }];
}

- (AccountModel *)accountModel {
    return [TyphoonDefinition withClass:[AccountModel class] configuration:^(TyphoonDefinition *definition) {
       definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (ExchangeService *)exchangeService {
    return [TyphoonDefinition withClass:[ExchangeService class] configuration:^(TyphoonDefinition *definition) {
       definition.scope = TyphoonScopeSingleton;
    }];
}

#pragma mark - ViewControllers

- (ExchangeViewController *)exchangeViewController {
    return [TyphoonDefinition withClass:[ExchangeViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(model) with:[self exchangeModel]];
    }];
}

@end