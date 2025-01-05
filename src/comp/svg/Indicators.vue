<template>
  <div class="tree-container">

    <div class="search-box">
      <input type="text" placeholder="Indikator ..." v-model="searchTerm" @input="filterIndicators" />
      <div class="search-icon"></div>
    </div>
    
    <h3 class="topics-inds">FTI-Bereiche & Indikatoren</h3>

    <div v-for="(node, index) in treeData" :key="node.id" class="tree-node">
      <div class="topics">
        <h3 class="topic">{{ node.nr }} {{ node.label }}</h3>
        <button class="btn-toggle" @click="toggleChildrenVisibility(index)">
          {{ unfoldedNodes[index] ? "▲" : "▼" }}
        </button>
      </div>

      <div class="indicators" :class="{ visible: unfoldedNodes[index] }">
        <div v-for="(indicator) in filteredIndicators(node.ind)" :key="indicator">
          <label class="indicator-checkbox">
            <input type="checkbox" :value="indicator" v-model="selectedIndicators" />
            {{ $store.getters.getShortname(indicator) }}
          </label>
        </div>
      </div>
    </div>

    <h3>Ausgewählte Indikatoren</h3>
    <ul>
      <li v-for="indicator in selectedIndicators" :key="indicator">
        {{ $store.getters.getShortname(indicator) }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      treeData: [],
      unfoldedNodes: {},
      selectedIndicators: [],
      searchTerm: "",
    };
  },
  mounted() {
    this.loadTreeData();
  },
  methods: {
    loadTreeData() {
      const ids = Object.keys(this.$store.getters.topics);
      this.treeData = ids.map(id => {
        const topic = this.$store.getters.topics[id];
        const indicators = this.$store.getters.topicIndicatorMap();
        return {
          id,
          nr: topic.nr,
          label: topic.name,
          ind: indicators.get(id),
        };
      });

      this.unfoldedNodes = this.treeData.reduce((acc, _, index) => {
        acc[index] = false;
        return acc;
      }, {});
    },

    toggleChildrenVisibility(index) {
      this.$set(this.unfoldedNodes, index, !this.unfoldedNodes[index]);
    },

    filterIndicators() {
      if (!this.searchTerm) {
        this.treeData.forEach((_, index) => {
          this.unfoldedNodes[index] = false;
        });
      } 
      else {
        this.treeData.forEach((node, index) => {
          const matchingIndicators = node.ind.filter(indicator =>
            this.$store.getters.getShortname(indicator).toLowerCase().includes(this.searchTerm.toLowerCase())
          );
          
          this.unfoldedNodes[index] = matchingIndicators.length > 0;
          node.filteredIndicators = matchingIndicators;
        });
      }
    },

    filteredIndicators(indicators) {
      return this.searchTerm ? indicators.filter(indicator =>
            this.$store.getters.getShortname(indicator).toLowerCase().includes(this.searchTerm.toLowerCase())) : indicators;
    }
  },
};
</script>

<style scoped>
.tree-container {
  display: block;
  width: 75%; /* Adjust as needed */
}

.tree-node {
  display: block;
}

.topics {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.topic {
  font-size: 16px;
  font-weight: bold;
}

.btn-toggle {
  background: none;
  border: none;
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  margin-left: 10px;
}

.btn-toggle:focus {
  outline: none;
}

.indicators {
  visibility: hidden;
  opacity: 0;
  max-height: 0;
  transition: opacity 0.4s ease, max-height 0.1s ease;
  padding-left: 10px;
}

.indicators.visible {
  visibility: visible;
  opacity: 1;
  max-height: 100vh;
}

.search-box {
  display: flex;
  align-items: center;
  border: 1px solid #ccc;
  border-radius: 10px;
  padding: 5px;
  background-color: white;
  width: 100%;
}

.search-box input[type="text"] {
  border: none;
  outline: none;
  font-size: 14px;
  flex: 1;
  padding-left: 10px;
}

.search-box input[type="text"]::placeholder {
  color: #aaa;
}

.search-box .search-icon {
  width: 18px;
  height: 18px;
  background-image: url('search.png');
  background-size: cover;
  background-repeat: no-repeat;
}

.topics-inds {
  padding-top: 15px;
  font-weight: 600;
}

.indicator-checkbox {
  display: flex;
  align-items: center;
  font-size: 16px;
  margin-bottom: 5px;
}

.indicator-checkbox input[type="checkbox"] {
  margin-right: 8px;
}

.selected-indicators {
  margin-top: 20px;
  border-top: 1px solid #ccc;
  padding-top: 10px;
}

.selected-indicators h3 {
  font-size: 16px;
  font-weight: bold;
}

.selected-indicators ul {
  list-style-type: none;
  padding-left: 0;
}

.selected-indicators li {
  font-size: 14px;
  padding: 5px 0;
}
</style>
