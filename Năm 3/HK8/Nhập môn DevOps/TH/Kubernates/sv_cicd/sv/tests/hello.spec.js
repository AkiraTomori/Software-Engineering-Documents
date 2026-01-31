const chai = require('chai');
const chaiHttp = require('chai-http');
const app = require('../index');

chai.use(chaiHttp);
const expect = chai.expect;

describe('Test App', () => {
    describe('GET /', () => {
        it('should return "Hello World 13!" for the / route', (done) => {
            chai.request(app)
                .get('/')
                .end((err, res) => {
                    expect(res).to.have.status(200);
                    expect(res.text).to.equal('<h1>Hello World gacon!</h1>');
                    done();
                });
        });
    });

    describe('GET /about', () => {
        it('should return "HCMUS" for the /about route', (done) => {
            chai.request(app)
                .get('/about')
                .end((err, res) => {
                    expect(res).to.have.status(200);
                    expect(res.text).to.equal('<h1>HCMUS</h1>');
                    done();
                });
        });
    });

    describe('GET /contact', () => {
        it('should return "FIT-HCMS" for the /contact route', (done) => {
            chai.request(app)
                .get('/contact')
                .end((err, res) => {
                    expect(res).to.have.status(200);
                    expect(res.text).to.equal('<h1>FIT-HCMS</h1>');
                    done();
                });
        });
    });

    describe('GET /hello', () => {
        it('should return "Quan Nguyen" for the /hello route', (done) => {
            chai.request(app)
                .get('/hello')
                .end((err, res) => {
                    expect(res).to.have.status(200);
                    expect(res.text).to.equal('Quan Nguyen');
                    done();
                });
        });
    });

    after(() => {
        console.log('Tests are completed');
        // forcefully exit the program
        process.exit(0); // Exit with success status
    });
});
