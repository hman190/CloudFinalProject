# include rmr2
library(rmr2)

# read csv file
train<-read.csv(file="small.csv",header=FALSE)
names(train)<-c("user","item","pref")

rmr.options(backend = 'hadoop')

#push data to hadoop
train.hdfs = to.dfs(keyval(train$user,train))

# construct a item, user, preference matrix
train.mr<-mapreduce(
  train.hdfs, 
  map = function(k, v) {
    key<-v$item
    val<-data.frame(item=v$item, user=v$user, pref=v$pref)
    keyval(key,val)
  }
)
#Calculate the inner product of two item
den<-function(x,y)
{
  if(x$user==y$user)
  {
    return(1)
  }
  else
  {
    if(x$item==y$item)
    {
      return(x$pref*y$pref)
    }
    else
    {
      return(0)
    }
  }
}
# Stuck here!!!
step2.mr<-mapreduce(
  train.mr,
  map = function(k, v) {
    d<-data.frame(v,v)
    d2<-ddply(d,.(v,v),den)

    key<-d2$v
    val<-d2
    keyval(key,val)
  }
)

