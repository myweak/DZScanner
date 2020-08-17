#pragma once

#include "Vec3.hpp"
#include <array>

namespace ObjToStl
{
struct Triangle
  {
  Triangle(const Vec3& vertex1, const Vec3& vertex2, const Vec3& vertex3);

  std::array<Vec3, 3> m_vertices;
  Vec3 m_normal;
  };

}
