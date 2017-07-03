# CONTRIBUTING

## Filing issues

Whether you find a bug, typo or an API call that could be clarified or our SDK recommends you to do so, please [file an issue](https://github.com/Off-Piste/Trolley.io/issues/new) on our GitHub repository.

When filing an issue, please provide as much of the following information as possible in order to help others fix it:

1. A Simple Overview Of The Error
2. Expected Results
3. Actual Results
4. Steps to Reproduce
5. Code Sample (full project links are ideal)
6. Version of Trolley / Xcode / OS
7. CocoaPod Version

### Speeding things up 🏃

You may just copy this little script below and run it directly in your project directory in Terminal.app. It will take of compiling a list of relevant data as described in points 6. and 7. in the list above. It copies the list directly to your pasteboard for your convenience, so you can attach it easily when filing a new issue without having to worry about formatting and we may help you faster because we don't have to ask for particular details of your local setup first.

```bash
echo "\`\`\`bash

$(sw_vers)

$(pod --version)
$(test -e Podfile.lock && cat Podfile.lock | sed -nE 's/ - (Trolley?.* [^:].*:):?/\1/p' || echo "(not in use here)")

$(xcode-select -p)
$(xcodebuild -version)

\`\`\`" | tee /dev/tty | pbcopy
```

## Enhancements
