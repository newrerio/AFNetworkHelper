# AFNetworkHelper
a network helper easy to use

## 网络通用类

基于AFNetwork，内置jwt和菊花的基本处理，提供了7种基本的网络请求  
postUrlWithoutAuth  
getUrl  
postUrl  
putUrl  
deleteUrl  
putImageToUrl  
postImagesToUrl  


可结合SuperJuhua使用，极其简单，如：  
GET：

	[AFNetworkHelper getUrl:kUserProfileUrl bg:NO param:nil succeed:^(id responseObject) {
	    if (isNull([responseObject objectForKey:@"user"]) == NO) {
	        [UserModel CacheUserAllData:[responseObject objectForKey:@"user"]];
	    }
	    [self loginSusseed:fromReigster];
	} fail:^{
	    hideJuHua(self.navigationController.view);
	}];

POST:
				
	[AFNetworkHelper postUrl:kNewSkillUrl bg:NO param:params succeed:^(id responseObject) {
	    if (self.isPresented) {
	        showAndHideRightJuHuaDone(@"添加成功",self.navigationController.view,^(){
	            [self.navigationController dismissViewControllerAnimated:YES completion:^{
	                
	            }];
	        });
	    }else{
	        showAndHideRightJuHua2Done(@"完成", @"前往首页即可发币",self.navigationController.view,^(){
	            [self.navigationController popViewControllerAnimated:YES];
	        });
	    }
	} fail:^{
	    hideJuHua(self.navigationController.view);
	}];

POST Image:

	//带多张图片的请求
	self.HUD = showJuHua(nil,self.navigationController.view);
	showPieJuHua(nil, self.navigationController.view, self.HUD);
	
	//图片data
	NSMutableArray *arrImgData = [[NSMutableArray alloc] init];
	if (self.isSelectOriginalPhoto) {
	    //原图
	    for (PHAsset *asset in _arrAssets) {
	        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
	        options.synchronous = YES;
	        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(1920, 1920) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
	            [arrImgData addObject:UIImageJPEGRepresentation([result imageByNormalizingOrientation], 0.85)];
	        }];
	    }
	}else{
	    for (UIImage *img in _arrPhotos) {
	        [arrImgData addObject:UIImageJPEGRepresentation([img imageByNormalizingOrientation], 0.98)];
	    }
	}
	
	[AFNetworkHelper postImagesToUrl:kNewSkillPicsUrl bg:NO params:params imgDatas:arrImgData uploadProgressBlock:^(NSProgress *uploadProgress) {
	    dispatch_async(dispatch_get_main_queue(), ^{
	        if ((int)uploadProgress.fractionCompleted == 1) {
	            incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
	            self.HUD.textLabel.text = @"稍等片刻";
	        }else{
	            incrementPieJuHua(self.HUD,(int)(uploadProgress.fractionCompleted*100));
	        }
	    });
	} succeed:^(id responseObject) {
	    if (self.isPresented) {
	        showAndHideRightJuHuaDone(@"添加成功",self.navigationController.view,^(){
	            [self.navigationController dismissViewControllerAnimated:YES completion:^{
	                
	            }];
	        });
	    }else{
	        showAndHideRightJuHua2Done(@"完成", @"前往首页即可发币",self.navigationController.view,^(){
	            [self.navigationController popViewControllerAnimated:YES];
	        });
	    }
	    
	} fail:^{
	    hideJuHua(self.navigationController.view);
	}];


​    
