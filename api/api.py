import nimporter
import faster_than_requests as requests

requests.get("http://httpbin.org/get")                                      # GET
requests.post("http://httpbin.org/post", "Some Data Here")                  # POST
requests.download("http://example.com/foo.jpg", "out.jpg")                  # Download a file
requests.scraper(["http://foo.io", "http://bar.io"], threads=True)          # Multi-Threaded Web Scraper
requests.scraper5(["http://foo.io"], sqlite_file_path="database.db")        # URL-to-SQLite Web Scraper
requests.scraper6(["http://python.org"], ["(www|http:|https:)+[^s]+[w]"]) # Regex-powered Web Scraper