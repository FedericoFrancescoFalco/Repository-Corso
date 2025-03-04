import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.datasets import load_iris

# Caricamento del dataset Iris
iris = load_iris()

print(iris["target_names"])
print(iris.target_names)

n_samples, n_features = iris.data.shape
print('Number of samples:', n_samples)
print('Number of features:', n_features)

# Mostra i dati del primo campione
print(iris.data[0])

# Creazione del grafico
# fig, ax = plt.subplots()
# x_index = 3  # Indice della feature da visualizzare
# colors = ['blue', 'red', 'green']

# # Iterazione sulle classi del dataset
# for label, color in zip(range(len(iris.target_names)), colors):
#     ax.hist(iris.data[iris.target == label, x_index], 
#             label=iris.target_names[label], 
#             color=color, 
#             alpha=0.6)  # Aggiunta trasparenza per migliore visibilitÃ

# ax.set_xlabel(iris.feature_names[x_index])
# ax.set_ylabel("Frequency")
# ax.legend(loc='upper right')
# plt.title("Distribution of feature: " + iris.feature_names[x_index])
# plt.show()
# fig, ax = plt.subplots()

# x_index = 3
# y_index = 0

# colors = ['blue', 'red', 'green']

# for label, color in zip(range(len(iris.target_names)), colors):
#     ax.scatter(iris.data[iris.target==label, x_index], 
#                 iris.data[iris.target==label, y_index],
#                 label=iris.target_names[label],
#                 c=color)

# ax.set_xlabel(iris.feature_names[x_index])
# ax.set_ylabel(iris.feature_names[y_index])
# ax.legend(loc='upper left')
# plt.show()

# n = len(iris.feature_names)
# fig, ax = plt.subplots(n, n, figsize=(16, 16))

# colors = ['blue', 'red', 'green']

# for x in range(n):
#     for y in range(n):
#         xname = iris.feature_names[x]
#         yname = iris.feature_names[y]
#         for color_ind in range(len(iris.target_names)):
#             ax[x, y].scatter(iris.data[iris.target==color_ind, x], 
#                              iris.data[iris.target==color_ind, y],
#                              label=iris.target_names[color_ind],
#                              c=colors[color_ind])

#         ax[x, y].set_xlabel(xname)
#         ax[x, y].set_ylabel(yname)
#         ax[x, y].legend(loc='upper left')


# plt.show()
#  PANDAS
iris_df = pd.DataFrame(iris.data, columns=iris.feature_names)
pd.plotting.scatter_matrix(iris_df, 
                           c=iris.target, 
                           figsize=(8, 8)
                          )

plt.show()