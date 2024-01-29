---
title: Data whitening used in RF
tags: [rf, whitening, lfsr, cc1101, rf69, rfm69, sx1231]
---

In RF communication systems, data whitening techniques are employed to address the issue of DC bias introduced by long sequences of 0s or 1s within transmitted data packets. It is crucial to eliminate these patterns as they can adversely affect signal integrity and synchronization. In this tutorial, we will explore the data whitening algorithms used in the CC1101 and RF69 (SX1231) chip families. Detailed descriptions of these algorithms can be found in the NXP application note https://www.nxp.com/docs/en/application-note/AN5070.pdf

## Introduction to Data Whitening

Data whitening involves modifying transmitted data to eliminate long sequences of consecutive 0s or 1s. By removing these patterns, data whitening improves synchronization and enhances the receiver's ability to detect and recover the original data accurately.

## Data Whitening Algorithms

Data Whitening Algorithms

There are two common data whitening algorithms: IBM and CCITT. These algorithms differ slightly in the way they generate the pseudo-random sequence used to modify the original data. The generated sequence is XORed with the original data to produce the whitened data, and it is XORed again at the receiver to recover the original data. The pseudo-random sequence is generated using a Linear Feedback Shift Register (LFSR) with a finite length of 64 bytes.

To implement data whitening, you need to implement the LFSR algorithm. However, for simplicity, you can use a pre-generated stream and XOR it with your data.

## IBM Whitening Algorithm LFSR

The full computed LFSR stream for IBM whitening is:

```
ffe11d9aed853324ea7ad2397097570a547d2dd86d0dba8f6759c7a2bf34ca18305393df92eca7158adcf486554e182140c4c4d5c6918acde7d14e093217df83
```

The IBM whitening algorithm is used by CC1101 chips and chip families.

## CCITT Whitening Algorithm LFSR

The full computed LFSR for CCITT whitening is:

```
ff87b859b7a1cc24575e4b9c0ee9ea502abeb41bb6b05df1e69ae345fd2c53180ccac9fb4937e5a8513b2f61aa721884022323ab638951b3e78b72904ce8fbc1
```

The CCITT whitening algorithm is used by RF69 (RFM69, SX1231) chips and chip families.

## Converting between whitening methods

To convert between IBM and CCITT whitening methods, you can use the XOR of both LFSR streams:

```
0066a5c35a24ff00bd2499a57e7ebd5a7ec399c3dbbde77e81c324e7421899003c995a24dbdb42bddbe7dbe7ff3c00a542e7e77ea518db7e005a3c997eff2442
```

This XOR key can be used to convert whitened data between the IBM and CCITT whitening algorithms.

## Ruby LFSR implementation example

Here's a Ruby implementation example demonstrating how to unwhiten data using the LFSR algorithm:

```ruby
whitened_data="0a2c34a6b8"

def unwhite(data,seed = 0x1ff)
  data = [data].pack("H*")
  xor_with_lsfr_stream([data,lsfr9_stream(seed,data.length))
end

def xor_with_lsfr_stream(data,stream)
  data.each_char.zip(stream).map{|x,y| (x.to_i(16) ^ y.to_i(16)).to_s(16)}.join
end

def lsfr9_stream(seed,length)
  stream = []
  9.times do
    stream << (seed & 1)
    seed = seed >> 1
  end
  (length*8).times do
    stream << ((stream[-9] ^ stream[-5]) & 1)
  end
  stream
end

unwhite(whitened_data)
```
