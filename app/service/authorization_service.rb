class AuthorizationService

    def initialize(headers = {})
      @headers = headers
    end
  
    def authenticate_request!
      verify_token
    end
  
    private
  
    def http_token
      if @headers['Authorization'].present?
        @headers['Authorization'].split(' ').last
      end
    end
  
    def verify_token
      if http_token == nil
        raise "token no present"
      else
        # simple compare
        if http_token != "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjE1Zk9hWVppX0d2bGVTQ3B6V1FaNyJ9.eyJpc3MiOiJodHRwczovL2Rldi0ycWtwbzI2dy51cy5hdXRoMC5jb20vIiwic3ViIjoiRXpVV29Sa2hIUlNTQXJQcDFJZU40VjFseXZzOHNyNU9AY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vcmFpbHMtc2VjdXJlLWFwaSIsImlhdCI6MTYzNDU2NzU2MiwiZXhwIjoxNjM0NjUzOTYyLCJhenAiOiJFelVXb1JraEhSU1NBclBwMUllTjRWMWx5dnM4c3I1TyIsImd0eSI6ImNsaWVudC1jcmVkZW50aWFscyJ9.XTTLkWUr8E0ZZTlCAutqfAIAlwyU6fSvtKqmnQlFlvAV_CX_o4jL0aHUFbsIn0zxoaFq3EjvK0bQ_8rENppKOpcaHe9H-qNeW--t1oV2VKZWLWQ6EBOoRmCkr_wU-PLJ1Np3SFKlcaAp-Xnt0HkVFXlI2F2N1G6F13Q8kbAZoJzovfIzqHxwQ61FmguL7b0LAqXOKlQJUl_pWFM_L7go9tMHZLLb8w0bpPsdxhWphXRgEMIXRoWWTiz1q7m8QaGAjf1y6DQYV36AEdIhAfPnah-w8UjL0k43wfzQe9mZZvPqS0Fd-6d7_fpfyUF2MSV2_k9gW5pXA7gVIo1XyKApJA"
          raise "token incorrect"
        end
      end
    end
  
  end