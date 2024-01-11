import json
import sys
import influxdb_client, os, time
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

class WriteDb:
   def __init__(self):
      #Influx接続用データ値
      self.token = "my-super-secret-auth-token"
      self.org = "FUSiON"
      self.bucket = "Data"
      self.url = "http://localhost:8086"

      #Client作成
      self.client = influxdb_client.InfluxDBClient(url=self.url, token=self.token, org=self.org)

      #API作成
      self.write_api = self.client.write_api(write_options=SYNCHRONOUS)

   def write(self, json_data):
      for tagkey in json_data:
         # API用のPOINT作成
         point = Point("FUSiON_CanSat")
         #POINTにタグ追加
         point.tag("_tag",tagkey)
         #Debug
         # print("============= _Tag = {} =============".format(tagkey))
         #FIELD分だけ回す愚直解法
         for fieldkey,values in json_data[tagkey].items():
               #POINTにFIELDを追加
               point.field(tagkey+'_'+fieldkey, values)
         #Debug    
         # print("Line:{}".format(point))
         #DB書き込み
         self.write_api.write(bucket=self.bucket, org=self.org, record=point)
