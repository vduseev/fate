
## Discovery use cases

### Discovery of test case files

#### Case A: Test files pair explicitly specified

**Given**:
1. CLI input
   ```shell
   fate discover --input-file "input.txt" --output-file "output.txt"
   ```
2. OR config in current dir: `.fate.json`
   ```json
   {
     "tests": {
       
     }
   }
   ```