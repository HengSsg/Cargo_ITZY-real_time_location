## Getting Start
1. `terraform init`을 해주세요
2. ./main.tf 의 line.37(버킷 이름)을 변경 해주세요
3. `terraform plan`입력과 엔터 두번을 눌러주세요
4. `terraform apply` 후 username 과 password를 입력해주세요

`apply`후에 혹시 아래와 같은 오류가 발생하면 다시한번 더 `terraform apply`를 진행해주세요.

```
Error: Error creating API Gateway Deployment: BadRequestException: The REST API doesn't contain any methods
```


`apply`후 `outputs`에서 `invoke_url`의 주소를 카피해서 요청바디(json)와 함께 `POST`를 해주세요

## Clean UP
- `terraform destroy` 입력후 엔터 두 번으로 변수설정 부분 스킵.
