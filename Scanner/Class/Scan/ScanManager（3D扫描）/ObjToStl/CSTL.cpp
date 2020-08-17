//
//  CSTL.cpp
//  Scanner
//
//  Created by zyq on 2018/9/20.
//  Copyright © 2018年 rrd. All rights reserved.
//

#include "CSTL.hpp"
#include<math.h>

CSTL::CSTL()
{
}

CSTL::~CSTL()
{
}

bool CSTL::SetStlInf(float *px, float *py, float *pz,
                     int *TriaNum1, int *TriaNum2, int *TriaNum3, int TriaTotalNum)
{
    bool success = false;
    
    vx = px;
    vy = py;
    vz = pz;
    
    triaV1 = TriaNum1;
    triaV2 = TriaNum2;
    triaV3 = TriaNum3;
    
    m_TriaNum = TriaTotalNum;
    
    success = true;
    return success;
}

bool CSTL::SaveStlASCII(char *pathname,char * filename)
{
    bool suc = true;
    char *savename = new char[100];
    sprintf(savename,"%s%s.ast",pathname,filename);
    
    char *fileInf = new char[200];
    sprintf(fileInf,"solid %s.ast  %s",filename,"by master");
    
    FILE *fp = fopen(savename,"w");
    fprintf(fp,"%s\n",fileInf);
    delete []savename;
    
    for(int i=0;i<m_TriaNum;i++)
    {
        int id= triaV1[i];
        float v1x = vx[id];
        float v1y = vy[id];
        float v1z = vz[id];
        
        id= triaV2[i];
        float v2x = vx[id];
        float v2y = vy[id];
        float v2z = vz[id];
        
        id= triaV3[i];
        float v3x = vx[id];
        float v3y = vy[id];
        float v3z = vz[id];
        
        float nx = (v1y-v3y)*(v2z-v3z)-(v1z-v3z)*(v2y-v3y);
        float ny = (v1z-v3z)*(v2x-v3x)-(v2z-v3z)*(v1x-v3x);
        float nz = (v1x-v3x)*(v2y-v3y)-(v2x-v3x)*(v1y-v3y);
        
        float nxyz = sqrt(nx*nx+ny*ny+nz*nz);
        
        fprintf(fp,"facet normal %f %f %f\n",nx/nxyz,ny/nxyz,nz/nxyz);
        fprintf(fp,"outer loop\n");
        fprintf(fp,"vertex %f %f %f\n",v1x,v1y,v1z);
        fprintf(fp,"vertex %f %f %f\n",v2x,v2y,v2z);
        fprintf(fp,"vertex %f %f %f\n",v3x,v3y,v3z);
        fprintf(fp,"endloop\n");
        fprintf(fp,"endfacet\n");
        
    }
    sprintf(fileInf,"endsolid %s.ast  %s",filename,"by master");
    fprintf(fp,"%s\n",fileInf);
    fclose(fp);
    
    delete []fileInf;
    
    
    
    return suc;
}

bool CSTL::SaveStlBinary(char *pathname,char * filename)
{
    
    bool suc = true;
    char *savename = new char[100];
    sprintf(savename,"%s%s.stl",pathname,filename);
    
    char *fileInf = new char[200];
    sprintf(fileInf,"solid %s.stl  %s",filename,"by master");
    
    FILE *fp = fopen(savename,"wb");
    delete []savename;
    
    
    float* dat = new float[12];
    
    fwrite(fileInf,sizeof(char),80,fp);
    fwrite(&m_TriaNum,sizeof(int),1,fp);
    
    for(int i=0;i<m_TriaNum;i++)
    {
        int id= triaV1[i];
        float v1x = vx[id];
        float v1y = vy[id];
        float v1z = vz[id];
        
        id= triaV2[i];
        float v2x = vx[id];
        float v2y = vy[id];
        float v2z = vz[id];
        
        id= triaV3[i];
        float v3x = vx[id];
        float v3y = vy[id];
        float v3z = vz[id];
        
        float nx = (v1y-v3y)*(v2z-v3z)-(v1z-v3z)*(v2y-v3y);
        float ny = (v1z-v3z)*(v2x-v3x)-(v2z-v3z)*(v1x-v3x);
        float nz = (v1x-v3x)*(v2y-v3y)-(v2x-v3x)*(v1y-v3y);
        
        float nxyz = sqrt(nx*nx+ny*ny+nz*nz);
        
        dat[0] = nx/nxyz;
        dat[1] = ny/nxyz;
        dat[2] = nz/nxyz;
        
        dat[3] = v1x;
        dat[4] = v1y;
        dat[5] = v1z;
        
        dat[6] = v2x;
        dat[7] = v2y;
        dat[8] = v2z;
        
        dat[9] = v3x;
        dat[10] = v3y;
        dat[11] = v3z;
        
        fwrite(dat,sizeof(float),12,fp);
        fwrite("wl",sizeof(char),2,fp);
        
    }
    
    fclose(fp);
    
    delete []dat;
    delete []fileInf;
    
    
    
    return suc;
    
}
