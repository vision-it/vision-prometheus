# vision-prometheus

[![Build Status](https://travis-ci.org/vision-it/vision-prometheus.svg?branch=production)](https://travis-ci.org/vision-it/vision-prometheus)

## Parameter

## Usage

Include in the *Puppetfile*:

```
mod 'vision_prometheus',
    :git => 'https://github.com/vision-it/vision-prometheus.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_prometheus::server
contain ::vision_prometheus::client
```

