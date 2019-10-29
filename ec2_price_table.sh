#!/bin/sh

curl -sSL https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/index.csv |
csvcut -K5 -C 'SKU,OfferTermCode,RateCode,instanceSKU,Intel AVX Available,Intel AVX2 Available,Intel Turbo Available,Normalization Size Factor,Instance Capacity - 10xlarge,Instance Capacity - 12xlarge,Instance Capacity - 16xlarge,Instance Capacity - 18xlarge,Instance Capacity - 24xlarge,Instance Capacity - 2xlarge,Instance Capacity - 32xlarge,Instance Capacity - 4xlarge,Instance Capacity - 8xlarge,Instance Capacity - 9xlarge,Instance Capacity - large,Instance Capacity - medium,Instance Capacity - xlarge,Pre Installed S/W,Physical Cores,Instance,PriceDescription,License Model,LeaseContractLength,PurchaseOption,OfferingClass,Product Family,serviceCode,Location Type,Currency,Unit,Storage Media,Volume Type,Max Volume Size,Max IOPS/volume,Max IOPS Burst Performance,Max throughput/volume,Provisioned,EBS Optimized,Group,Group Description,Transfer Type,From Location,From Location Type,To Location,To Location Type,Elastic Graphics Type,GPU Memory,serviceName,usageType,EffectiveDate,StartingRange,EndingRange' |
csvgrep -c 'Operating System' -m Linux |
csvgrep -c TermType -m OnDemand |
csvgrep -c Tenancy -m Shared |
csvgrep -c CapacityStatus -m Used |
csvgrep -c operation -r '^RunInstances$' |
csvcut -C 'Operating System,TermType,Tenancy,CapacityStatus,operation' |
csvsql --query "update stdin set Memory = replace(Memory, ' GiB', ''); select * from stdin" |
csvformat -U0 |
tee aws_price.csv
