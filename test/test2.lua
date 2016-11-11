require 'torch'
local bm3d = require 'bm3d'
require 'image'
require 'randomkit'
require 'pprint'

local factor = 1
local sigma = 0.2

local l = image.lena():float()

local s= l:size():totable()

pprint(l)

-- PSNR = 10*log10(1/mean((y(:)-y_est(:)).^2))

local noise = randomkit.normal(l:clone(), 0,sigma)
local l_noisy = l:clone():add(noise)

-- image.save('lena_noisy.png',l_noisy/l_noisy:max())
-- l_noisy = image.load('lena_noisy.png'):float() * factor
-- print('l_noisy:max() '..l_noisy:max())
local basic = l_noisy:clone():zero()
local l_denoised = l_noisy:clone():zero()

bm3d.bm3d(sigma*factor,l_noisy,basic,l_denoised)

image.save('lena_norml.png',l)
print('saving basic')
image.save('lena_basic.png',basic/basic:max())
print('saving l_denoised')
image.save('lena_dnois.png',l_denoised/l_denoised:max())

local lena = image.load('lena_noisy.png')
local mse = torch.mean(l:csub(l_denoised))^2
local PSNR = 10* torch.log(1/mse)/(torch.log(10))
print(string.format('PSNR = %g dB',PSNR))
