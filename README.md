# prc_app

Built with Flutter, this application provides a convenient way for users to find the price of a product by simply taking an image of it.

[PRC API](https://github.com/humanova/prc_service) accepts an image of a product, and returns its price data from various online stores. Product name is extracted from the image using **EasyOCR**. The price data is then retrieved from **Cimri.com** and cached (for an hour) using **Redis**. To handle the bad OCR output, a **Fuzzy Matching** algorithm is applied to **DuckDuckGo** search results before querying the Cimri API.

## Demo


https://github.com/humanova/prc_app/assets/22047571/87ead096-307b-499a-89a1-c80412de1f1e

