# LogDemo
解决NSLog字典，数组，集合时中文显示Unicode问题

#前言
平时开发调试时，`NSLog( )`函数肯定没少用，不管是打印服务器返回的JSON数据，还是打印自己构造的数据。但是，当`NSDictionary`，`NSArray`，`NSSet`中有中文字符时，`NSLog`输出的是中文的Unicode码：
######1）NSDictionary :
```
   NSDictionary *dict = @{
                           @"名字" : @"杰克",
                           @"年龄" : @20,
                         }; 
   NSLog(@"%@", dict);
```
![NSDictionary中有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-2737f611cac50f47.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
######2）NSArray :
```
    NSArray *array = @[
                       @"语文",
                       @"数学",
                       @"外语",
                       ];
   NSLog(@"%@", array);
```

![NSArray中有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-c085f24a36390029.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######3）NSSet :
```
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"语文"];
    [mSet addObject:@"数学"];
    [mSet addObject:@"外语"];
    NSLog(@"%@", mSet);
```
![NSSet中有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-6b2c178678e3b154.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
关于`NSSet`，上面的输出还不是最糟的，再来看看这个：
```
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"语文"];
    [mSet addObject:@"数学"];
    [mSet addObject:@"外语"];

    NSMutableArray *mArray = @[].mutableCopy;
    [mArray addObject:mSet];
    NSLog(@"%@", mArray);
```
![NSArray中嵌套NSSet时的输出](http://upload-images.jianshu.io/upload_images/3125169-11b9235bbb5a17b9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#解决方法
### 1. NSJSONSerialization
调用`NSJSONSerialization`的类方法，将`NSDictionary`和`NSArray`对象转换成JSON格式的`NSData`数据，再将`NSData`数据转成`NSString`输出。
```
+ (nullable NSData *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error;
```
`opt`参数传`NSJSONWritingPrettyPrinted`这个枚举值

NSDictionary的输出：
```
    NSDictionary *dict = @{
                           @"名字" : @"杰克",
                           @"年龄" : @20,
                      };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding
    NSLog(@"%@",str);
```
![NSJSONSerialization之后的NSDictionary的输出](http://upload-images.jianshu.io/upload_images/3125169-50c90a8d7cd1215c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


NSArray的输出：
```
    NSArray *array = @[
                       @"语文",
                       @"数学",
                       @"外语",
                       ];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
```
NSSet的输出：
```
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"语文"];
    [mSet addObject:@"数学"];
    [mSet addObject:@"外语"];
    
    // 这一行将使程序crash，因为NSSet的对象找不到对应的JSON格式的数据
    NSData *data = [NSJSONSerialization dataWithJSONObject:mSet options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
```


![NSJSONSerialization之后的NSSet，程序crash](http://upload-images.jianshu.io/upload_images/3125169-64560b453aadfc52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
程序crash的原因是JSONObject不支持`NSSet`类型，因为`NSSet`的对象找不到对应的JSON格式的数据
### 2. Category
NSDictionay，NSArray，NSSet类型的实例用NSLog输出时，都会调用
```
- (NSString *)descriptionWithLocale:(id)locale
```
只需分别创建`NSDictionay`，`NSArray`，`NSSet`的Category，覆盖系统的`- (NSString *)descriptionWithLocale:(id)locale`方法，当`NSLog`时，系统将会调用我们创建的Category中的方法。
在`- (NSString *)descriptionWithLocale:(id)locale`方法中创建`NSMutableString`的实例，逐个拼接集合对象中的元素。这三个Category，我已经写好了放在Github上了将Demo中的Foundation+Log.m文件添加到工程中，我们再来看看`NSDictionay`，`NSArray`，`NSSet`实例的输出。

######1）NSDictionary
```
    NSDictionary *dict = @{
                           @"名字" : @"杰克",
                           @"年龄" : @20,
                           };
    NSLog(@"%@", dict);
```

![NSDictionary中有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-fbd60cb21e856135.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
######2）NSArray
```
    NSArray *array = @[
                       @"语文",
                       @"数学",
                       @"外语",
                       ];
    
    NSLog(@"%@", array);
```

![NSArray中有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-654cd79fa57926d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######3）NSSet
```
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"语文"];
    [mSet addObject:@"数学"];
    [mSet addObject:@"外语"];
    
    NSLog(@"%@", mSet);
```
 
![NSSet中有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-ca0c23b363d0925b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######4）NSDictionary + NSArray
```
    NSDictionary *dict = @{@"名字" : @"杰克",
                           @"年龄" : @12,
                           @"内容" : @{
                                   @"userName" : @"rose",
                                   @"message" : @"好好学习",
                                   @"testArray" : @[@"数学",
                                                    @"英语",
                                                    @"历史",
                                                    @[
                                                        @"zhangsan",
                                                        @"lisi",
                                                        @[
                                                            @"test1",
                                                            @"test2",
                                                            @"test3"
                                                            ],
                                                        ],
                                                    ],
                                   @"test" : @{
                                           @"key1" : @"测试1",
                                           @"键值2" : @"test2",
                                           @"key3" : @"test3"
                                           }
                                   
                                   },
                           
                           
                           };
    NSLog(@"%@", dict);
```

![NSDictionary + NSArray有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-df39324ef6311000.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######5）NSSet + NSArray
```
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"语文"];
    [mSet addObject:@"数学"];
    [mSet addObject:@"外语"];
    
    NSMutableArray *mArray = @[].mutableCopy;
    [mArray addObject:mSet];
    
    NSLog(@"%@", mArray);
```

![NSSet + NSArray有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-42774b966edbab8e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

######6）NSSet + NSArray + NSDictionary
```
    NSMutableSet *mSet = [NSMutableSet set];
    [mSet addObject:@"英语"];
    [mSet addObject:@"历史"];
    [mSet addObject:@"数学"];
    
    NSArray *arr = @[@"a", @"b", @"c"];
    [mSet addObject:arr];
    
    NSMutableSet *subSet = mSet.mutableCopy;
    NSMutableSet *subSubSet = mSet.mutableCopy;
    [subSet addObject:subSubSet];
    [mSet addObject:subSet];
    
    NSDictionary *subDict = @{
                              @"键0" : @"值0",
                              @"键1" : @"值1",
                              @"键2" : @"值2",
                              };
    [mSet addObject:subDict];
    NSDictionary *dict = @{@"something" : mSet};
    
    NSLog(@"%@", dict);
```

![NSSet + NSArray + NSDictionary有中文时的输出](http://upload-images.jianshu.io/upload_images/3125169-8d81de730214e3c8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#性能
对比我实现的Category方法和系统方法的执行时间
```
- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        for (NSInteger i = 0; i < 1000; ++i) {
            NSMutableSet *mSet = [NSMutableSet set];
            [mSet addObject:@"英语"];
            [mSet addObject:@"历史"];
            [mSet addObject:@"数学"];
            
            NSArray *arr = @[@"a", @"b", @"c"];
            [mSet addObject:arr];
            
            NSMutableSet *subSet = mSet.mutableCopy;
            NSMutableSet *subSubSet = mSet.mutableCopy;
            [subSet addObject:subSubSet];
            [mSet addObject:subSet];
            
            NSDictionary *subDict = @{
                                      @"键0" : @"值0",
                                      @"键1" : @"值1",
                                      @"键2" : @"值2",
                                      };
            [mSet addObject:subDict];
            NSDictionary *dict = @{@"something" : mSet};
            
            NSLog(@"%@", dict);

        }

    }];
}
```
执行一次NSLog的时间
系统的方法：0.582s / 1000
我的方法：0.893s /1000


