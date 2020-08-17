#pragma once

namespace ObjToStl
{
struct Vec3
  {
  double x;
  double y;
  double z;
  };

Vec3 operator*(const Vec3& lhs, const Vec3& rhs);

}
