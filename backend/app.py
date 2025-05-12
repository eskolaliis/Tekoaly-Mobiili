from flask import Flask, request, jsonify
from flask_cors import CORS
from recipes import recipes  # tuo reseptit sisään

app = Flask(__name__)
CORS(app)

@app.route('/generate', methods=['POST'])
def generate_recipe():
    data = request.get_json()
    ingredients = set(map(str.lower, data.get('ingredients', [])))

    if not ingredients:
        return jsonify({'error': 'No ingredients provided'}), 400

    def score(recipe):
        recipe_ingredients = set(map(str.lower, recipe['ingredients']))
        return len(ingredients & recipe_ingredients)

    sorted_recipes = sorted(recipes, key=score, reverse=True)
    top_matches = sorted_recipes[:3]

    result = []
    for r in top_matches:
        result.append({
            'name': r['name'],
            'ingredients': r['ingredients'],
            'instructions': r['instructions']
        })

    return jsonify({'recipes': result})

if __name__ == '__main__':
    app.run(debug=True)