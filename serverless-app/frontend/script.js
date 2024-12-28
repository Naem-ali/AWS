async function createItem() {
    const itemName = document.getElementById('itemName').value;

    const response = await fetch('https://<your-api-id>.execute-api.us-east-1.amazonaws.com/dev/create-item', {
        method: 'POST',
        body: JSON.stringify({ itemName }),
        headers: { 'Content-Type': 'application/json' },
    });

    const result = await response.json();
    document.getElementById('message').innerText = result.message;
}
