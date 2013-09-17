# evil_transform

[ruby译]地球坐标系 (WGS-84) 到火星坐标系 (GCJ-02) 的转换算法

Code from https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936

## Usage

```ruby
gem install evil_transform
``` 

```ruby
EvilTransform.to_MGS(lat: 39.909745000000, lon: 116.359496000000)
# => [39.911112866392486, 116.36569790916941]

EvilTransform.new(lat: 39.909745000000, lon: 116.359496000000).to_MGS
# => [39.911112866392486, 116.36569790916941]
```

## Methods

* #to_MGS _Mars Geodetic System_
* #to_WGS _World Geodetic System_
* #to_BGS _Baidu Geodetic System_
* #bgs_to_MGS _Baidu Geodetic System ==> Mars Geodetic System_
