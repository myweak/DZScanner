//
//  CSTL.hpp
//  Scanner
//
//  Created by zyq on 2018/9/20.
//  Copyright © 2018年 rrd. All rights reserved.
//

#ifndef CSTL_hpp
#define CSTL_hpp

#include <stdio.h>

class CSTL
{
private:
    float *vx;
    float *vy;
    float *vz;
    
    int *triaV1;
    int *triaV2;
    int *triaV3;
    
    int m_TriaNum;
public:
    
    CSTL();
    ~CSTL();
public:
    bool SetStlInf(float *px,float *py,float *pz,
                   int *TriaNum1,int *TriaNum2,int *TriaNum3,int TriaTotalNum);
    bool SaveStlBinary(char *pathname,char * filename);
    bool SaveStlASCII(char *pathname,char * filename);
    
    
};
#endif /* CSTL_hpp */
