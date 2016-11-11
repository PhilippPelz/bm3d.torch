local classic = require 'classic'
local ffi = require 'ffi'
local argcheck = require 'argcheck'
require 'pprint'
local bm3d = classic.module(...)
bm3d.lib = ffi.load(package.searchpath('libbm3d', package.cpath))

local bm3d_h = [[
TH_API int run_bm3d(const float sigma, THFloatTensor *img_noisy1,
                    THFloatTensor *img_basic1,
                    THFloatTensor *img_denoised1, const unsigned width,
                    const unsigned height, const unsigned chnls,
                    const bool useSD_h, const bool useSD_w,
                    const unsigned tau_2D_hard, const unsigned tau_2D_wien,
                    const unsigned color_space);
]]
local preprocessed = string.gsub(bm3d_h, 'TH_API ', '')
ffi.cdef(preprocessed)

bm3d.run_bm3d = bm3d.lib['run_bm3d']
bm3d.YUV =       0
bm3d.YCBCR  =   1
bm3d.OPP    =   2
bm3d.RGB   =   3
bm3d.DCT   =    4
bm3d.BIOR  =    5
bm3d.HADAMARD = 6
bm3d.NONE    =  7

function bm3d.bm3d_full(sigma,noisy,basic,denoised,useSD_h,useSD_w,tau_2D_hard,tau_2D_wien)
  local s = noisy:size():totable()
  bm3d.run_bm3d(sigma,noisy:cdata(),basic:cdata(),denoised:cdata(),s[2],s[3],s[1],useSD_h,useSD_w,tau_2D_hard,tau_2D_wien,bm3d.OPP)
end
function bm3d.bm3d(sigma,noisy,basic,denoised)
  bm3d.bm3d_full(sigma,noisy,basic,denoised,false,false,bm3d.BIOR,bm3d.BIOR)
end
return bm3d
