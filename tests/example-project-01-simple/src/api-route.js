class ApiResponse {
  constructor(data) {
    this.data = data;
  }
}

export async function GET() {
  return new ApiResponse({ message: 'hello from GET' });
}

export async function POST() {
  return new ApiResponse({ message: 'hello from POST' });
}
