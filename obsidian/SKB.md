[[SKB memset 0]]
[[SKB Memory Allocation and Freeing]]

http://vger.kernel.org/~davem/skb_data.html
### skb_reserve
Reserve head room. Advances the data and tail pointer header_len bytes
### skb_put
Advances the tail pointer data_len bytes to make room between skb->data and skb->tail for copying data and increments skb->len. **skb_put_data** will also copy the data and not just advance tail
### skb_push
Decrements the data pointer to make room above the current data pointer for adding data there (usually a new header) and increments skb->len.

### skb len and linear vs non-linear data
The skb->len is how many bytes the packet is in total including paged data. If the skb needs more data than has been allocated in skb->head (the linear data buffer) it can use paged data fragments stored in the skb.shinfo->frags. The field skb->data_len is the number of bytes stored in frags so `skb->len - skb->data_len` is the number of bytes stored linearly in skb->head (**skb_headlen** calculates this).