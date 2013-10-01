#!/usr/bin/env julia

using Images
using ImageView

# read in an image and convert it into an array
function readimages(fn)
  image1 = imread(fn)
  image1 = convert(Array{Uint8,3},image1)
  image1_gs = rgb2gray(float64(image1))
  return image1, image1_gs
end

# split the image into 4 separate screens
function splitimage(image::Array{Float64,2})
  siz = size(image)
  sx = siz[1]
  sy = siz[2]
  halfx = sx/2
  halfy = sy/2
  sc1 = image[1:halfx,1:halfy];
  sc2 = image[halfx+1:sx,1:halfy];
  sc3 = image[halfx+1:sx,halfy+1:sy];
  sc4 = image[1:halfx,halfy+1:sy];
  return sc1,sc2,sc3,sc4
end
# for rgb:
function splitimage(image::Array{Uint8,3})
  siz = size(image)
  sx = siz[1]
  sy = siz[2]
  halfx = sx/2
  halfy = sy/2
  sc1 = image[1:halfx,1:halfy,:];
  sc2 = image[halfx+1:sx,1:halfy,:];
  sc3 = image[halfx+1:sx,halfy+1:sy,:];
  sc4 = image[1:halfx,halfy+1:sy,:];
  return sc1,sc2,sc3,sc4
end



function main()
  image1,image1_gs = readimages("2012-06-19-00/00000807.ppm")
  image2,image2_gs = readimages("2012-06-19-00/00000807.ppm")
  println(size(image1))

  screen1_1,screen2_1,screen3_1,screen4_1 = splitimage(image1)
  screen1_2,screen2_2,screen3_2,screen4_2 = splitimage(image2)

  # find the most common rgb value:
  common = [screen1_1[1,1,:] => 1]
  for i = 1:size(screen1_1,1)
    for j = 1:size(screen1_1,2)
      key = screen1_1[i,j,:]
      if haskey(common, key)
        common[key] += 1
      else
        common[key] = 1
      end
    end
  end
  maxkey = screen1_1[1,1,:]
  maxval = 0
  for k in keys(common)
    if common[k] > maxval
      maxval = common[k]
      maxkey = k
    end
  end

  println("max key:", maxkey, " max val: ", maxval)

  mask = zeros(Uint8,(size(screen1_1,1),size(screen1_1,2)))
  eps = 20

  for i = 1:size(screen1_1,1)
    for j = 1:size(screen1_1,2)
      if norm( vec(float64(screen1_1[i,j,:]))-vec(float64(maxkey)) ) < eps
        mask[i,j] = 1
      end
    end
  end

  display(255*mask, xy=["y","x"])

  #display(uint8(floor(image1)))
  display(uint8(floor(screen1_1)), xy=["y","x"])
  #display(uint8(floor(screen2_1)), xy=["y","x"])
  #display(uint8(floor(screen3_1)), xy=["y","x"])
  #display(uint8(floor(screen4_1)), xy=["y","x"])

  #display(uint8(floor(image2)))
  #display(uint8(floor(screen1_2)), xy=["y","x"])
  #display(uint8(floor(screen2_2)), xy=["y","x"])
  #display(uint8(floor(screen3_2)), xy=["y","x"])
  #display(uint8(floor(screen4_2)), xy=["y","x"])
end

main()
