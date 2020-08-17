//
//  Obj2Stl.cpp
//  Scanner
//
//  Created by zyq on 2018/9/21.
//  Copyright © 2018年 rrd. All rights reserved.
//

#include "Obj2Stl.hpp"
#include <fstream>
#include <iostream>
#include <string>
#include <stdio.h>
#include <math.h>

namespace ObjTStl
{
    // Namespaces
    using std::cout ;
    using std::endl ;
    using std::ifstream ;
    using std::ofstream ;
    using std::string ;
    using std::vector ;
    
    // 3D Vector
    struct Vec3d {
        double x , y , z ;
    } ;
    
    // Triangular polygon
    struct Tri {
        int vIndex[3] , norm ;
    } ;
    
    // Object file
    struct Obj {
        std::vector<Vec3d> verts , norms ;
        std::vector<Tri>   tris ;
    } ;
    
    // Write STL file
    int stlWrite ( char *path , Obj obj ) {
        
        // Try to open file
        ofstream stlFile ;
        stlFile.open ( path ) ;
        
        if ( !stlFile.is_open() ) { return -1 ; }
        
        // Write solid header
        stlFile << "solid s" << endl ;
        
        // Write face by face
        for ( int i = 0 ; i < obj.tris.size() ; i++ ) {
            // Line format storage
            char line[128] ;
            
            // Write face header
            sprintf ( line , "  facet normal %lf %lf %lf\n" , obj.norms[ obj.tris[i].norm - 1 ].x , obj.norms[ obj.tris[i].norm - 1 ].y , obj.norms[ obj.tris[i].norm - 1 ].z ) ;
            stlFile << line ;
            stlFile << "    outer loop" << endl ;
            
            // Write vertex loop
            for ( int j = 0 ; j < 3 ; j++ ) {
                sprintf ( line , "      vertex %lf %lf %lf\n" , obj.verts[ obj.tris[i].vIndex[j] - 1 ].x*1000 , obj.verts[ obj.tris[i].vIndex[j] - 1 ].y*1000 , obj.verts[ obj.tris[i].vIndex[j] - 1 ].z*1000 ) ;
                stlFile << line ;
            }
            
            //Write face footer
            stlFile << "    endloop" << endl ;
            stlFile << "  endfacet" << endl ;
        }
        
        
        // Write solid footer
        stlFile << "endsolid s" << endl ;
        
        // Close file
        stlFile.close ( ) ;
        
        return 0 ;
        
    }
    
    int saveStlBinary( char *path , Obj obj )
    {
        char *savename = new char[100];
        sprintf(savename,"%s",path);
        
        char *fileInf = new char[200];
        sprintf(fileInf,"solid %s.stl  %s","filename","by master");
        
        FILE *fp = fopen(savename,"wb");
        delete []savename;
        
        
        float* dat = new float[12];
        
        fwrite(fileInf,sizeof(char),80,fp);
        fwrite(&obj.tris,sizeof(int),1,fp);
        
        for(int i=0;i<obj.tris.size();i++)
        {
        
            float v1x = obj.verts[ obj.tris[i].vIndex[0] - 1 ].x*1000;
            float v1y = obj.verts[ obj.tris[i].vIndex[0] - 1 ].y*1000;
            float v1z = obj.verts[ obj.tris[i].vIndex[0] - 1 ].z*1000;
            
            float v2x = obj.verts[ obj.tris[i].vIndex[1] - 1 ].x*1000;
            float v2y = obj.verts[ obj.tris[i].vIndex[1] - 1 ].x*1000;
            float v2z = obj.verts[ obj.tris[i].vIndex[1] - 1 ].x*1000;
            
            float v3x = obj.verts[ obj.tris[i].vIndex[2] - 1 ].x*1000;
            float v3y = obj.verts[ obj.tris[i].vIndex[2] - 1 ].x*1000;
            float v3z = obj.verts[ obj.tris[i].vIndex[2] - 1 ].x*1000;
            
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
        return 0;
        
    }
    
    
    
    // Load object file
    int objLoad ( char* path , Obj *object ) {
        
        // Try to open file
        ifstream objFile ;
        objFile.open ( path ) ;
        
        if ( ! objFile.is_open() ) { return -1 ; }
        
        string line ;
        
        // Read file line by line
        while ( getline ( objFile , line ) ) {
            if ( line[0] == 'v' && line[1] == ' ' ) {
                // Vertex line
                Vec3d newVert ;
                sscanf ( line.c_str() , "v %lf %lf %lf" , &newVert.x , &newVert.y , &newVert.z ) ;
                object -> verts.push_back ( newVert ) ;
            } else if ( line[0] == 'v' && line[1] == 'n' ) {
                // Normal line
                Vec3d newNorm ;
                sscanf ( line.c_str() , "vn %lf %lf %lf" , &newNorm.x , &newNorm.y , &newNorm.z ) ;
                object -> norms.push_back ( newNorm ) ;
            } else if ( line[0] == 'f' ) {
                // Face line
                Tri newTri ;
                sscanf ( line.c_str() , "f %i//%*i %i//%*i %i//%i", &newTri.vIndex[0] , &newTri.vIndex[1] , &newTri.vIndex[2] , &newTri.norm ) ;
                object -> tris.push_back ( newTri ) ;
            }
        }
        
        // Close file
        objFile.close ( ) ;
        
        return 0 ;
        
    }
    //obj文件转stl
    bool loadStl(char* objPath,char* stlPath){
        // Create object storage
        Obj obj ;
        
        // Run loading method
        if ( objLoad ( objPath , &obj ) < 0 ) {
            return -1 ;
        }
        
        // Run writing method
        if ( stlWrite ( stlPath , obj ) < 0 ) {
            return -1;
        }
        return 1;
    }
}



