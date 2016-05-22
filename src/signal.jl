### Signal Processing 

import Base: fft, ifft, fft!, ifft!

export fftC2R, fftR2C

# FFTs

for (op, fn) in ((:fft, :af_fft), (:ifft, :af_ifft))

    @eval function ($op){T<:Real}(a::AFVector{T}; norm_factor = 1., dim1 = 0)
        out = new_ptr()
        eval($fn)(out, a, norm_factor, dim1)
        AFArray{Complex{T}}(out[])
    end

    @eval function ($op){T<:Complex}(a::AFVector{T}; norm_factor = 1., dim1 = 0)
        out = new_ptr()
        eval($fn)(out, a, norm_factor, dim1)
        AFArray{T}(out[])
    end

end

for (op, fn) in ((:fft, :af_fft2), (:ifft, :af_ifft2))

    @eval function ($op){T<:Real}(a::AFMatrix{T}; norm_factor = 1., dim1 = 0, dim2 = 0)
        out = new_ptr()
        eval($fn)(out, a, norm_factor, dim1, dim2)
        AFArray{Complex{T}}(out[])
    end

    @eval function ($op){T<:Complex}(a::AFMatrix{T}; norm_factor = 1., dim1 = 0, dim2 = 0)
        out = new_ptr()
        eval($fn)(out, a, norm_factor, dim1, dim2)
        AFArray{T}(out[])
    end

end

for (op, fn) in ((:fft, :af_fft3), (:ifft, :af_ifft3))

    @eval function ($op){T<:Real}(a::AFArray{T,3}; norm_factor = 1., dim1 = 0, dim2 = 0, dim3 = 0)
        out = new_ptr()
        eval($fn)(out, a, norm_factor, dim1, dim2, dim3)
        AFArray{Complex{T}}(out[])
    end

    @eval function ($op){T<:Complex}(a::AFArray{T,3}; norm_factor = 1., dim1 = 0, dim2 = 0, dim3 = 0)
        out = new_ptr()
        eval($fn)(out, a, norm_factor, dim1, dim2, dim3)
        AFArray{T}(out[])
    end

end

for (op, fn) in ((:fft, :af_fft), (:ifft, :af_ifft))

    @eval function ($op){T<:Real}(a::AFArray{T}, dim::Integer)
        out = new_ptr()
        if dim == 1
            eval($fn)(out, a, 1., 0)
        else
            throw("This dimension is not currently supported")
        end
        AFArray{Complex{T}}(out[])
    end

    @eval function ($op){T<:Complex}(a::AFArray{T}, dim::Integer)
        out = new_ptr()
        if dim == 1
            eval($fn)(out, a, 1., 0)
        else
            throw("This dimension is not currently supported")
        end
        AFArray{T}(out[])
    end

end

for (op, fn) in ((:fft!, :af_fft_inplace), (:ifft!, :af_ifft_inplace))

    @eval function ($op){T<:Real}(a::AFVector{T}; norm_factor = 1.)
        eval($fn)(a, norm_factor)
        a
    end

    @eval function ($op){T<:Complex}(a::AFVector{T}; norm_factor = 1.)
        eval($fn)(a, norm_factor)
        a
    end

end

for (op, fn) in ((:fft!, :af_fft2_inplace), (:ifft!, :af_ifft2_inplace))

    @eval function ($op){T<:Real}(a::AFMatrix{T}, norm_factor = 1.)
        eval($fn)(a, norm_factor)
        a
    end

    @eval function ($op){T<:Complex}(a::AFMatrix{T}, norm_factor = 1.)
        eval($fn)(a, norm_factor)
        a
    end

end

for (op, fn) in ((:fft!, :af_fft3_inplace), (:ifft!, :af_ifft3_inplace))

    @eval function ($op){T<:Real}(a::AFArray{T,3}, norm_factor = 1.)
        eval($fn)(a, norm_factor)
        a
    end

    @eval function ($op){T<:Complex}(a::AFArray{T,3}, norm_factor = 1.)
        eval($fn)(a, norm_factor)
        a
    end

end

for (arr, fn) in ((:(AFVector{Complex{T}}), :af_fft_c2r), (:(AFMatrix{Complex{T}}), :af_fft2_c2r),
                    (:(AFArray{Complex{T},3}), :af_fft3_c2r))

    @eval function fftC2R{T<:Real}(a::($arr); is_odd = false, norm_factor = 0.)
        out = new_ptr()
        eval($fn)(out, a, norm_factor, is_odd)
        AFArray{T}(out[])
    end

end

function fftR2C{T}(a::AFVector{T}, pad1::Integer; norm_factor = 0.)
    out = new_ptr()
    af_fft_r2c(out, a, norm_factor, pad1)
    AFArray{Complex{T}}(out[])
end
     
function fftR2C{T}(a::AFMatrix{T}, pad1::Integer, pad2::Integer; norm_factor = 0.)
    out = new_ptr()
    af_fft2_r2c(out, a, norm_factor, pad1)
    AFArray{Complex{T}}(out[])
end

function fftR2C{T}(a::AFArray{T,3}, pad1::Integer, pad2::Integer, pad3::Integer; norm_factor = 0.)
    out = new_ptr()
    af_fft3_r2c(out, a, norm_factor, pad1)
    AFArray{Complex{T}}(out[])
end