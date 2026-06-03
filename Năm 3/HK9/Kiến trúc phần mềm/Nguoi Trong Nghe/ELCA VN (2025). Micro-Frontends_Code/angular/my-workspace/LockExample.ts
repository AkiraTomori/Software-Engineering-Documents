export class ApiService {
  constructor(private http: HttpClient) {}

  getData(): Observable<any> {
    return this.http.get('https://api.example.com/data');
  }
}

export class ApiService {
  constructor(private httpFetch: HttpFetch) {}

  async getData(): Promise<any> {
    const response = await this.httpFetch.get('https://api.example.com/data');
    return response.json(); // Parses the response to JSON
  }
}
