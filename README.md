
# ✨ DelegateCall Contract & Wrong Way To Make an Upgradeable Proxy✨
An example of delegatecall, a low level function similar to call.
When contract A executes delegatecall to contract B, B's code is executed with contract A's storage.

Here's how it works:
1. Contract A calls Contract B using delegatecall.
2. Contract B's code is executed within the context of Contract A.
3. Any read/write operations done by Contract B will use Contract A's storage instead of its own.

The storage implication is critical here:
- Read Operations: When Contract B reads data, it reads from Contract A's storage. So, it sees Contract A's data as if it were its own.
- Write Operations: When Contract B writes data, it updates Contract A's storage, not its own. This is essential to be aware of because unintended changes might occur in Contract A's storage.
Due to this behavior, using delegatecall requires extra care and consideration. It's commonly used in smart contract upgradability patterns and proxy contracts, but you need to be cautious about potential storage clashes or security risks when using delegatecall. Incorrect use of delegatecall can lead to unexpected behavior and vulnerabilities in the contract's functionality.

This repo is a ***WRONG*** way to implement an Upgradeable Proxy.

1. We have two contracts: `WrongProxy` and `CounterV1`.

2. We set the `implementation` address variable in `WrongProxy` to the address of `CounterV1` by calling `wrongProxy.upgradeTo(address(counterV1))`. This means that now `WrongProxy` will execute the code of `CounterV1`.

3. Next, we build a new `CounterV1` contract at the address of `wrongProxy` by doing `wrongCounterV1 = CounterV1(address(wrongProxy))`.

4. Now, when we call the `Inc()` function of `CounterV1` contract through the `wrongProxy` contract, we are actually using the `wrongProxy` storage for `CounterV1`.

5. In `CounterV1` contract, the `count` variable is stored in a specific memory slot, let's say slot 1.

6. When we execute the `Inc()` function, it will try to increment the value stored in slot 1 (which should be the `count` variable). However, since we are using `wrongProxy` storage, the `Inc()` function ends up incrementing the value stored at the `implementation` address inside `wrongProxy` instead of the `count` value.

7. As a result, we are not updating the `CounterV1` contract's `count` variable, and the implementation inside `wrongProxy` remains incorrect.

In simple terms, the mistake lies in using the `wrongProxy` storage when calling `CounterV1`'s functions, which leads to unintended behavior and incorrect results.

## Requirements 🔧
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
  - You'll know you've installed Foundry right if you can run:
    - `forge --version` and get an output like: `forge x.x.x`

# Usage 📝

## Deploy 🚀

```
forge create --rpc-url INSERT_RPC_API_ENDPOINT \
--private-key YOUR_PRIVATE_KEY \
src/MultiCall.sol:MultiCall
```

### Compile 📝

```
forge build
```

## Testing 🧪

```
forge test
```


## Generate Documentation 📝

You can generate documemtation by adding NatSpecs to your contract and run:

```
forge doc --serve --port 4000
```
## Estimate gas 💸

You can estimate gas running:

```
forge test --fork-url FORK_URL -vvv --gas-report
```