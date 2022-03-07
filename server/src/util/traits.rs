use crate::util::byte_buffer::*;
use byteorder::ByteOrder;
use std::mem::size_of;

pub trait BufferPut {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B>;
}

pub trait BufferTake {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self where Self: Sized;
}

pub trait TryBufferTake {
    fn try_take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Option<Self> where Self: Sized;
}

impl<T> TryBufferTake for T
where
    T: BufferTake + Sized,
{
    fn try_take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Option<Self> {
        if size_of::<Self>() <= buffer.get_remaining() {
            Some(buffer.take::<Self>())
        } else {
            None
        }
    }
}

impl BufferPut for u8 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_u8(self)
    }
}

impl BufferPut for i8 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_i8(self)
    }
}

impl BufferPut for bool {
    fn put<B: ByteOrder>(self, buffer: &mut ByteBuffer<B>) -> &mut ByteBuffer<B> {
        buffer.put_u8(self as u8)
    }
}

impl BufferTake for u8 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_u8()
    }
}

impl BufferTake for i8 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_i8()
    }
}

impl BufferPut for u16 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_u16(self)
    }
}

impl BufferPut for i16 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_i16(self)
    }
}

impl BufferTake for u16 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_u16()
    }
}

impl BufferTake for i16 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_i16()
    }
}

impl BufferPut for u32 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_u32(self)
    }
}

impl BufferPut for i32 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_i32(self)
    }
}

impl BufferTake for u32 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_u32()
    }
}

impl BufferTake for i32 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_i32()
    }
}

impl BufferPut for u64 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_u64(self)
    }
}

impl BufferPut for i64 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_i64(self)
    }
}

impl BufferTake for u64 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_u64()
    }
}

impl BufferTake for i64 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_i64()
    }
}

impl BufferPut for u128 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_u128(self)
    }
}

impl BufferPut for i128 {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_i128(self)
    }
}

impl BufferTake for u128 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_u128()
    }
}

impl BufferTake for i128 {
    fn take<B: ByteOrder>(buffer: &mut ByteBuffer<B>) -> Self {
        buffer.take_i128()
    }
}

impl BufferPut for &[u8] {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_slice(self)
    }
}

impl BufferPut for Vec<u8> {
    fn put<B: ByteOrder>(
        self,
        buffer: &mut ByteBuffer<B>,
    ) -> &mut ByteBuffer<B> {
        buffer.put_slice(&self)
    }
}
