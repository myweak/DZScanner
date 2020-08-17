//
//  JassonSTLView.m
//  Scanner
//
//  Created by zyq on 2018/10/24.
//  Copyright © 2018年 rrd. All rights reserved.
//

#import "JassonSTLView.h"
#import <AFNetworking/AFNetworking.h>
//#import "MBProgressHUD.h"
@interface JassonSTLView ()
@end

@implementation JassonSTLView

- (void)dealloc{

}

- (instancetype)initWithSTLPath:(NSString *)path
{
    if (self = [super init])
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //调用显示STL文件的方法
            [self initSceneWithSTLPath:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD dismiss];
            });
        });
    }
    return self;
}

- (void)initSceneWithSTLPath:(NSString *)path
{
    //整个场景的背景颜色
    self.backgroundColor = [UIColor blackColor];
    //使用场景的默认光照
    self.autoenablesDefaultLighting = YES;
    //允许手动旋转
    self.allowsCameraControl = YES;

    self.antialiasingMode = SCNAntialiasingModeMultisampling4X;
    
    //创建一个空的场景
    SCNScene *scene = [SCNScene scene];
    self.scene = scene;
    
    //载入节点
    SCNNode *node = [self loadSTLWithPath:path];
    //修改节点的默认位置为X(0)、Y(0)、Z(0)
    node.position = SCNVector3Make(0, 0, 0);
    //添加节点到根节点
    [scene.rootNode addChildNode:node];
}
- (SCNNode *)loadSTLWithPath:(NSString *)path_Field
{
    SCNNode *node = nil;
    NSData *data  = [NSData dataWithContentsOfFile:path_Field];
    if (data.length > 80)
    {
        //为什么取前80个字节请查看前面的STL文件解析
        NSData *headerData = [data subdataWithRange:NSMakeRange(0, 80)];
        NSString *headerStr = [[NSString alloc] initWithData:headerData encoding:NSASCIIStringEncoding];
        if ([headerStr containsString:@"solid"])
        {
            //ASCII编码的STL文件
            node = [self loadASCIISTLWithData:data];
        }
        else
        {
            //载入二进制的STL文件
            node = [self loadBinarySTLWithData:[data subdataWithRange:NSMakeRange(84, data.length - 84)]];
        }
    }
    return node;
}

- (SCNNode *)loadBinarySTLWithData:(NSData *)data
{
    //顶点信息
    NSMutableData *vertices = [NSMutableData data];
    //法线信息
    NSMutableData *normals = [NSMutableData data];
    //可以暂时理解为编号信息
    NSMutableData *elements = [NSMutableData data];
    if (data.length % 50 != 0)
    {
        NSLog(@"STL(二进制)文件错误");
        return nil;
    }
    NSInteger allCount = data.length/50;
    //为什么要这样解析，还是请查看文章开始提到的STL文件解析
    for (int i = 0; i < allCount; i ++)
    {
        for (int j = 1; j <= 3; j ++)
        {
            [normals appendData:[data subdataWithRange:NSMakeRange(i * 50, 12)]];
            [vertices appendData:[data subdataWithRange:NSMakeRange(i * 50 + j*12, 12)]];
        }
        int element[3] = {(int)i * 3,(int)i*3 + 1,(int)i*3 + 2};
        [elements appendBytes:&element[0] length:sizeof(element)];
    }
    SCNGeometrySource *verticesSource = [SCNGeometrySource geometrySourceWithData:vertices semantic:SCNGeometrySourceSemanticVertex vectorCount:allCount*3 floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(SCNVector3)];
    SCNGeometrySource *normalsSource = [SCNGeometrySource geometrySourceWithData:normals semantic:SCNGeometrySourceSemanticNormal vectorCount:allCount*3 floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(SCNVector3)];
    SCNGeometryElement *geoMetryElement = [SCNGeometryElement geometryElementWithData:elements primitiveType:SCNGeometryPrimitiveTypeTriangles primitiveCount:allCount bytesPerIndex:sizeof(int)];
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[verticesSource,normalsSource] elements:@[geoMetryElement]];
    //纹理的颜色，也就是3D模型的颜色
    geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    //创建节点模型
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    return node;
}
- (SCNNode *)loadASCIISTLWithData:(NSData *)data
{
    //顶点信息
    NSMutableData *vertices = [NSMutableData data];
    //法线信息
    NSMutableData *normals = [NSMutableData data];
    //编号信息
    NSMutableData *elements = [NSMutableData data];
    NSString *asciiStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSArray *asciiStrArr = [asciiStr componentsSeparatedByString:@"\n"];
    int elementCount = 0;
    for (int i = 0; i < asciiStrArr.count; i ++)
    {
        NSString *currentStr = asciiStrArr[i];
        if ([currentStr containsString:@"facet"])
        {
            if ([currentStr containsString:@"normal"])
            {
                for (int j = 1; j <= 3; j++)
                {
                    NSArray *subNormal = [currentStr componentsSeparatedByString:@" "];
                    SCNVector3 normal = SCNVector3Make([subNormal[subNormal.count - 3] floatValue], [subNormal[subNormal.count - 2] floatValue], [subNormal[subNormal.count - 1] floatValue]);
                    [normals appendBytes:&normal length:sizeof(normal)];
                    NSArray *subVertice = [asciiStrArr[i+j+1] componentsSeparatedByString:@" "];
                    SCNVector3 vertice = SCNVector3Make([subVertice[subVertice.count - 3] floatValue], [subVertice[subVertice.count - 2] floatValue], [subVertice[subVertice.count - 1] floatValue]);
                    [vertices appendBytes:&vertice length:sizeof(vertice)];
                }
                int element[3] = {elementCount * 3,elementCount * 3 + 1,elementCount * 3 + 2};
                elementCount++;
                [elements appendBytes:&element length:sizeof(element)];
                i = i+6;
            }
        }
    }
    SCNGeometrySource *verticesSource = [SCNGeometrySource geometrySourceWithData:vertices semantic:SCNGeometrySourceSemanticVertex vectorCount:(elementCount-1)*3 floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(SCNVector3)];
    SCNGeometrySource *normalsSource = [SCNGeometrySource geometrySourceWithData:normals semantic:SCNGeometrySourceSemanticNormal vectorCount:(elementCount-1)*3 floatComponents:YES componentsPerVector:3 bytesPerComponent:sizeof(float) dataOffset:0 dataStride:sizeof(SCNVector3)];
    SCNGeometryElement *geoMetryElement = [SCNGeometryElement geometryElementWithData:elements primitiveType:SCNGeometryPrimitiveTypeTriangles primitiveCount:elementCount - 1 bytesPerIndex:sizeof(int)];
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[verticesSource,normalsSource] elements:@[geoMetryElement]];
    [geometry.firstMaterial setDoubleSided:YES];//SCNMaterial渲染器是否渲染前面和后面，默认只渲染前面
    //在节点处添加模型
    SCNNode *node = [SCNNode nodeWithGeometry:geometry];
    return node;
}
@end
