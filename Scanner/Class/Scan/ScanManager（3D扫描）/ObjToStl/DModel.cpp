
#include "DModel.hpp"

#include "Triangle.hpp"
#include "Vec3.hpp"
#include <string>
#include <sstream>
#include <ostream>
#include <iostream>
#include <fstream>

namespace ObjToStl
{
using Face = std::vector<int>;
Vec3 GetVertex(std::istringstream& str_stream);
Face GetFace(std::istringstream& str_stream);
std::vector<Triangle> Triangulate(const std::vector<Vec3>& vertices, const Face& face);

void writez()
{
    std::ofstream obj_stream("/Users/zyq/Downloads/HelloCpp-master/HelloCpp/Model/out.txt");
    if (obj_stream.is_open())
    {
        obj_stream << "This is a line.\n";
        obj_stream << "This is another line.\n";
        obj_stream.close();
    }
    
    
//    std::ofstream file("new_create.txt", std::fstream::out);
//    if (file) std::cout << " new file created" << std::endl;
//
//
//    const char* p_filename = "/Users/zyq/Downloads/HelloCpp-master/HelloCpp/Model/out.txt";
//    std::ofstream fout;//也可以在声明时同时打开文件 ofstream fout(p_filename);
//    fout.open(p_filename);//只接受const char* 的参数
//    if(!fout){
//        std::cout<<"file open failed.\n";
//        exit(0);//程序退出
//    }
//    fout<<"file open success and now write something into it.";
//    fout.close();//记得关闭文件流
}
    
void Write3DModelToStl(const Model3D& model_3d, std::ostream& o_stream)
  {
  o_stream << "solid ascii" << std::endl;
      
  //zyq
//  char *savename = new char[100];
//  sprintf(savename,"%s%s.stl","zyq","zyq");
//
//  char *fileInf = new char[200];
//  sprintf(fileInf,"solid %s.stl  %s","zyq","by master");
//
//  FILE *fp = fopen(savename,"w");
//  fprintf(fp,"%s\n",fileInf);
//  delete []savename;
  //zyq
      
  for(auto& t : model_3d)
    {
        
   //zyq
//   int id= t.m_vertices[i];
//   float v1x = vx[id];
//   float v1y = vy[id];
//   float v1z = vz[id];
//
//   id= t.m_vertices[i];
//   float v2x = vx[id];
//   float v2y = vy[id];
//   float v2z = vz[id];
//
//   id= t.m_vertices[i];
//   float v3x = vx[id];
//   float v3y = vy[id];
//   float v3z = vz[id];
//
//   float nx = (v1y-v3y)*(v2z-v3z)-(v1z-v3z)*(v2y-v3y);
//   float ny = (v1z-v3z)*(v2x-v3x)-(v2z-v3z)*(v1x-v3x);
//   float nz = (v1x-v3x)*(v2y-v3y)-(v2x-v3x)*(v1y-v3y);
//
//   float nxyz = sqrt(nx*nx+ny*ny+nz*nz);
//
//   fprintf(fp,"facet normal %f %f %f\n",nx/nxyz,ny/nxyz,nz/nxyz);
//   fprintf(fp,"outer loop\n");
//   fprintf(fp,"vertex %f %f %f\n",v1x,v1y,v1z);
//   fprintf(fp,"vertex %f %f %f\n",v2x,v2y,v2z);
//   fprintf(fp,"vertex %f %f %f\n",v3x,v3y,v3z);
//   fprintf(fp,"endloop\n");
//   fprintf(fp,"endfacet\n");
   //zyq
        
        
    o_stream << "facet normal " << t.m_normal.x << " " << t.m_normal.x << " " << t.m_normal.x << std::endl;
    o_stream << " outer loop" << std::endl;
    for(auto& v : t.m_vertices)
      {
      o_stream << "  vertex " << v.x << " " << v.y << " " << v.z << std::endl;
      }
        
        //zyq
//        sprintf(fileInf,"endsolid %s.ast  %s",filename,"by master");
//        fprintf(fp,"%s\n",fileInf);
//        fclose(fp);
//        delete []fileInf;
        //zyq
        
    o_stream << " endloop" << std::endl;
    o_stream << "endfacet" << std::endl;
    o_stream << std::endl;
    }
    o_stream << "endsolid" << std::endl;
  }
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Model3D Get3DModelFromObj(std::istream& i_stream)
  {
  std::vector<Vec3> vertices;
  std::vector<Face> faces;
  while(!i_stream.eof())
    {
    std::string line;
    std::getline(i_stream, line);
    std::istringstream str_stream(line);
    std::string type;
    str_stream >> type;
    if(type == "v")
      {
      vertices.push_back(GetVertex(str_stream));
      }
    else if(type == "f")
      {
      faces.push_back(GetFace(str_stream));
      }
    }

  Model3D model_3d;
  for(auto& f : faces)
    {
    std::vector<Triangle> temp_triangles = Triangulate(vertices, f);
    model_3d.insert(model_3d.end(), temp_triangles.begin(), temp_triangles.end());
    }
  return model_3d;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

std::vector<Triangle> Triangulate(const std::vector<Vec3>& vertices, const Face& face)
  {
  if(face.size() == 3)
    {
    return{ Triangle(vertices[face[0]], vertices[face[1]], vertices[face[2]]) };
    }

  std::vector<Triangle> triangulated;
  for(auto i = 1; i <= face.size() - 2; ++i)
    {
    triangulated.push_back(Triangle{ vertices[face[0]], vertices[face[i]], vertices[face[i + 1]] });
    }
  return triangulated;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Vec3 GetVertex(std::istringstream& str_stream)
  {
  Vec3 vertex;
  std::string temp_str;

  str_stream >> temp_str;
  vertex.x = std::stod(temp_str);
  str_stream >> temp_str;
  vertex.y = std::stod(temp_str);
  str_stream >> temp_str;
  vertex.z = std::stod(temp_str);

  return vertex;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Face GetFace(std::istringstream& str_stream)
  {
  Face face;
  std::string temp_str;
  while(!str_stream.eof())
    {
    str_stream >> temp_str;
    std::replace(temp_str.begin(), temp_str.end(), '/', ' ');
    face.push_back(std::stoi(temp_str) - 1);
    }
  return face;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
